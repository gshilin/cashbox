class Admin::CashdesksController < ApplicationController
  before_action :set_cash_desk, only: [:show, :edit, :update, :destroy]

  def index
    set_all_desks
  end

  def show
  end

  def new
    @desk = Cashdesk.new
  end

  def edit
  end

  def create
    @desk = Cashdesk.new(cash_desk_params)

    respond_to do |format|
      if @desk.save
        format.html { redirect_to admin_cashdesks_path, notice: 'CashDesk was successfully created.' }
        format.json { render :show, status: :created, location: @desk }
      else
        format.html { render :new }
        format.json { render json: @desk.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @desk.update(cash_desk_params)
        format.html { redirect_to admin_cashdesks_path, notice: 'CashDesk was successfully updated.' }
        format.json { render :show, status: :ok, location: @desk }
      else
        format.html { render :edit }
        format.json { render json: @desk.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @desk.destroy
    respond_to do |format|
      format.html { redirect_to admin_cashdesks_url, notice: 'CashDesk was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicate
    desk         = Cashdesk.find(params[:id])
    desc        = desk.dup
    desc.number = Cashdesk.maximum(:number) + 1
    desc.save

    set_all_desks
    render :index
  end

  private

  def set_all_desks
    @desks = Cashdesk.order(:system_name, number: :asc).all
  end

  def set_cash_desk
    @desk = Cashdesk.find(params[:id])
  end

  def cash_desk_params
    params.fetch(:cash_desk, {}).permit(:number, :cc_label, :nis_label, :usd_label, :eur_label, :pelecard_ShopNo, :system_name)
  end
end
