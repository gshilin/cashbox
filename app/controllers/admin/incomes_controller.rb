class Admin::IncomesController < ApplicationController

  def index
  end

  def show
    @desk          = Cashdesk.find(params[:id])
    @shift         = Shift.find(params[:shift])
    @shift_incomes = @shift.incomes.order(id: :desc)
  end
end
