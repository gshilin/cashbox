class Admin::HomesController < ApplicationController

  def index
    @totals = Shift.totals
  end
end
