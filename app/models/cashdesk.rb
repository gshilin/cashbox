class Cashdesk < ApplicationRecord
  has_many :shifts, dependent: :destroy
  has_many :incomes, through: :shifts

  after_create -> (desk) {
    desk.shifts << Shift.create(state: 'inactive')
  }

  def last_shift
    shifts.order(created_at: :desc).first
  end
end
