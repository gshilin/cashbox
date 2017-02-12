class Admin::IncomesController < ApplicationController

  def index
  end

  def show
    @desk          = Cashdesk.find(params[:id])
    @shift         = Shift.find(params[:shift])
    @shift_incomes = @shift.incomes.order(id: :asc)
    @amounts       = @shift.amounts
  end

  # cancel
  def destroy
    income = Income.find_by(id: params[:id])
    income.update_attributes(cancelled: !income.cancelled)

    redirect_to admin_income_path(id: params[:desk], shift: params[:shift])
  end

end
