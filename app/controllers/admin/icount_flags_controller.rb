class Admin::IcountFlagsController < ApplicationController

  def index
    @flag = IcountFlag.first
  end

  def new
    @flag = IcountFlag.first
    @flag.update_attributes use_icount: !@flag.use_icount
    redirect_to admin_icount_flags_path
  end
end
