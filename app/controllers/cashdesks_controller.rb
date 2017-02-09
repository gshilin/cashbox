class CashdesksController < ApplicationController
  def index
    @desks = Cashdesk.order(:system_name, number: :asc).group(:system_name, :id).all
  end

  def show
    @desk = Cashdesk.find_by(id: params[:id])
    @shift = @desk.shifts.order(created_at: :desc).first
  end
end
