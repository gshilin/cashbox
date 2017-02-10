require 'rest_client'

class Icount

  CURRENCY = {
      USD: '2',
      EUR: '1',
      ILS: '5'
  }

  def generate_receipt(income_id, label, payment_args)
    icount_logger.info "####### #{Time.now} executing request for #{income_id}"
    income = Income.find_by(id: income_id)
    unless income
      icount_logger.info "Unable to find Income #{income_id}"
      return false
    end

    icount_logger.info "executing request for #{income.name}"

    params = {
        compID:            terminal,
        user:              user,
        pass:              password,
        dateissued:        (Time.now + TZInfo::Timezone.get('Asia/Jerusalem').current_period.offset.utc_total_offset).strftime('%Y%m%d'),
        clientname:        income.name.blank? ? 'כללי' : income.name,
        client_country:    'IL',
        docType:           'receipt',
        income_type_name:  label,
        currency:          CURRENCY[income.currency.to_sym],
        es:                'קבלה לעם - אישור תשלום',
        hwc:               'חנות ספרים',
        sendOrig:          'gshilin@gmail.com',
        receipt_type_name: 'no_group',
        lang:              'he',
        eft:               'בלינק המצורף תוכל להוריד קבלה על התשלום שביצעת: ',

        show_response:     1
    }
    params.merge! self.send("set_#{income.kind}", payment_args, income)

    rest = RestClient::Resource.new(
        'https://api.icount.co.il/api/create_doc_auto.php',
        verify_ssl:  OpenSSL::SSL::VERIFY_PEER,
        ssl_ca_file: File.join(Rails.root, 'config', 'certificates', 'cacert.pem')
    )
    begin
      @response = parse_response(get_response(rest, params))
      icount_logger.info "Invoice for payment: #{params}: #{@response}"
      post_invoice_process
    rescue Exception => e
      icount_logger.info "Response: #{@response}"
      icount_logger.info "Message: #{e.message}"
      icount_logger.info "Backtrace:\n#{e.backtrace.inspect}"
      params.merge!(debug: 'yes')
      icount_logger.info "Params: #{params}"
      @response = parse_response(get_response(rest, params))
      icount_logger.info "Could not submit invoice for payment: #{params}: #{@response}"
      false
    end
  end

  private

  def get_response(rest, params)
    rest.post(params) { |response|
      case response.code
        when 301, 302, 307
          response.follow_redirection
        else
          response.return!
      end
    }
  end

  def parse_response(res)
    return nil unless res.is_a? String
    res.body.split(' ').inject({}) do |h, s|
      k, v = s.split(/\=/, 2)
      h[k] = v
      h
    end
  end

  def post_invoice_process
    if success?
      icount_logger.info "Success to generate invoice, invoice_url: #{invoice_url}"
      invoice_url
    else
      icount_logger.info 'Could not generate invoice'
      false
    end
  end

  def invoice_url
    @response['EMAIL_LINK'] rescue nil
  end

  def success?
    @response['REQUEST_OK'] == '1' && @response['EMAIL_LINK'].present? rescue false
  end

  def set_cc(args, income)
    amount      = args[:amount].to_f
    payments_no = args[:payments_num] || 1

    response = {
        credit:            1,
        'cc_cardtype[]':   case income.pelecard.cc_hebrew_name
                             when 'ויזה'
                               1
                             when 'כאל'
                               1
                             when 'לאומי כארד'
                               1
                             when 'דיינרס'
                               4
                             when 'אמריקן אקספרס'
                               5
                             when 'ישראכרט'
                               6
                             else
                               7
                           end,
        'cctotal[]':       amount.to_s,
        'cc_cardnumber[]': income.pelecard.cc_number,
        'cc_holdername[]': income.name
    }

    if payments_no > 1
      payment_diff       = amount % payments_no
      periodical_payment = (amount - payment_diff) / payments_no
      first_payment      = (periodical_payment + payment_diff).to_f

      response.merge!('cc_paymenttype[]': '2', 'cc_numofpayments[]': payments_no, 'ccfirstpayment[]': first_payment)
    else
      response.merge!('cc_paymenttype[]': '1')
    end

    response
  end

  def set_nis(args, income)
    {
        cash:       '1',
        cashamount: args[:cashamount].to_f.to_s
    }
  end

  def set_usd(args, income)
    {
        cash:       '1',
        cashamount: args[:cashamount].to_f.to_s
    }
  end

  def set_eur(args, income)
    {
        cash:       '1',
        cashamount: args[:cashamount].to_f.to_s
    }
  end

  def terminal
    @terminal ||= Rails.configuration.general_settings['icount']['comp_id']
  end

  def user
    @user ||= Rails.configuration.general_settings['icount']['user']
  end

  def password
    @password ||= Rails.configuration.general_settings['icount']['pass']
  end

  def icount_logger
    @logger           ||= Logger.new("#{Rails.root}/log/icount.log")
    @logger.formatter = proc { |severity, datetime, progname, msg|
      Logger::Formatter.new.call(severity, datetime, progname, msg.dump)
    }
    @logger
  end
end
