class Shift < ApplicationRecord
  belongs_to :cashdesk
  has_many :incomes

  def amounts
    # incomes.successful.where(kind: %w(nis usd eur), currency: currency).sum(&:amount)
    # incomes.successful.where(kind: %w(cc), currency: currency).sum(&:amount)
    sql = <<-SQL.html_safe
      SELECT lower(currency) currency, SUM(amount)
      FROM incomes
      WHERE shift_id = #{id} AND success = true AND cancelled = false AND kind IN ('nis', 'usd', 'eur') 
      GROUP BY currency
    SQL
    cash = Shift.connection.execute(sql)
    nis = usd = eur = 0
    cash.each do |c|
      case c['currency']
        when 'ils'
          nis = c['sum']
        when 'usd'
          usd = c['sum']
        when 'eur'
          eur = c['sum']
        else
          raise "Unknown currency #{c['currency']}"
      end
    end
    sql  = <<-SQL.html_safe
      SELECT SUM(amount)
      FROM incomes
      WHERE shift_id = #{id} AND success = true AND cancelled = false AND kind IN ('cc')
    SQL
    cc = Shift.connection.execute(sql)

    {
        cc: cc[0]['sum'],
        nis: nis,
        usd: usd,
        eur: eur
    }
  end

  def self.totals
    sql = <<-SQL.html_safe
      SELECT lower(currency) currency, SUM(amount)
      FROM incomes
      WHERE success = true AND cancelled = false AND kind IN ('nis', 'usd', 'eur') 
      GROUP BY currency
    SQL
    cash = self.connection.execute(sql)
    nis = usd = eur = 0
    cash.each do |c|
      case c['currency']
        when 'ils'
          nis = c['sum']
        when 'usd'
          usd = c['sum']
        when 'eur'
          eur = c['sum']
        else
          raise "Unknown currency #{c['currency']}"
      end
    end
    sql  = <<-SQL.html_safe
      SELECT SUM(amount)
      FROM incomes
      WHERE success = true AND cancelled = false AND kind IN ('cc')
    SQL
    cc = self.connection.execute(sql)

    {
        cc: cc[0]['sum'] || 0,
        nis: nis,
        usd: usd,
        eur: eur
    }
  end
end
