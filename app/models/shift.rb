class Shift < ApplicationRecord
  belongs_to :cashdesk
  has_many :incomes

  def cc_amount
    incomes.successful.where(kind: 'cc').sum(&:amount)
  end

  def cash_amount(currency = 'ILS')
    incomes.successful.where(kind: ['nis', 'usd', 'eur'], currency: currency).sum(&:amount)
  end

  def self.totals
    Shift.all.inject({cc: 0, nis: 0, usd: 0, eur: 0}) do |memo, s|
      memo[:cc]  += s.cc_amount
      memo[:nis] += s.cash_amount('ILS')
      memo[:usd] += s.cash_amount('USD')
      memo[:eur] += s.cash_amount('EUR')
      memo
    end
  end
end
