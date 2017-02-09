class PelecardsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def good_url
    pelecard = Pelecard.find_by(user_key: params[:UserKey])
    err, msg = pelecard.approve params
    if err == 0
      pelecard.income.update_attributes success: true
      # TODO ZZZ pelecard.income.request_receipt
      msg = 'Accepted'
    end
    redirect_to cashdesk_shift_path(pelecard.cashdesk, pelecard.shift, msg: "#{err}: #{msg}")
  end

  def error_url
    pelecard = Pelecard.find_by(user_key: params[:UserKey])
    pelecard.update_attributes transaction_id: params[:PelecardTransactionId],
                               status_code:    params[:PelecardStatusCode].to_i
    redirect_to cashdesk_shift_path(pelecard.cashdesk, pelecard.shift,
                                    msg: params[:PelecardStatusCode] + ': ' + Pelecard::MESSAGES[params[:PelecardStatusCode].to_sym])
  end

  def cancel_url
    pelecard = Pelecard.find_by(user_key: params[:UserKey])
    pelecard.update_attributes transaction_id: params[:PelecardTransactionId],
                               status_code:    params[:PelecardStatusCode].to_i
    redirect_to cashdesk_shift_path(pelecard.cashdesk, pelecard.shift, msg: 'עיסקה בוטלה')
  end
end
