module ApplicationHelper
  def income_class(income)
    if income.cancelled then
      'danger'
    elsif income.success == true then
      ''
    else
      'warning'
    end
  end
end
