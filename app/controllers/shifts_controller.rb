class ShiftsController < ApplicationController
  def show
    @desk          = Cashdesk.find_by(id: params[:cashdesk_id])
    @shift         = @desk.last_shift
    @shift_incomes = @shift.incomes.successful_inc_cancel.order(id: :desc).limit(50)
    @message       = params[:msg]
    @err           = params[:err].to_i
    @income        = Income.new(shift: @shift, name: params[:name], amount: params[:amount])
  end

  def new
    desk  = Cashdesk.find_by(id: params[:cashdesk_id])
    shift = Shift.create(state: 'active')
    desk.shifts << shift

    redirect_to cashdesk_shift_path(desk, shift)
  end

  def destroy
    shift = Shift.find_by(id: params[:id])
    shift.update_attributes(state: 'inactive')

    redirect_to cashdesk_path(shift.cashdesk)
  end
end
