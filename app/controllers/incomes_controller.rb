class IncomesController < ApplicationController
  def create
    @income = Income.create(income_params) do |t|
      t.kind, t.currency = getKindAndCurrency(params[:commit])
    end
    if @income.errors.any?
      render :errors and return
    end

    if @income.kind == 'cc'
      pelecard       = Pelecard.create!(income_id: @income.id)
      transaction_id = "bb-#{@income.id}-#{@income.shift.id}-#{@income.shift.cashdesk.number}-#{Time.now.to_i}"
      err, msg       = pelecard.redirect_url(@income.shift.id, @income.amount, @income.shift.cashdesk.number, transaction_id,
                                             good_url_pelecards_url, error_url_pelecards_url, cancel_url_pelecards_url)
      if err != 0
        render js: '$("#status").html("' + msg .gsub(/"/, "''")+ '");'
      else
        render js: "location = '#{msg}'"
      end
    else
      @shift = Shift.find_by(id: params[:income][:shift_id])
      @income.update_attributes success: true
      @income.request_receipt
    end
  end

  private

  def getKindAndCurrency(kind)
    case kind
      when '₪'
        %w(nis ILS)
      when '$'
        %w(usd USD)
      when '€'
        %w(eur EUR)
      when 'כרטיס אשראי'
        %w(cc ILS)
    end
  end

  def income_params
    params.fetch(:income, {}).permit(:name, :amount, :shift_id)
  end

end
