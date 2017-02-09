module Admin
  class HomesController < ApplicationController

    def index
      @totals = Shift.totals
    end
  end
end
