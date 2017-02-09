class Income < ApplicationRecord
  belongs_to :shift
  has_one :icount
  has_one :pelecard

  validates_presence_of :name, :amount, message: 'חובה למלא'
  validates_numericality_of :amount, greater_than: 0, message: 'חייב להיות חיובי'

  CURRENCY = {
      USD: '$',
      EUR: '€',
      ILS: '₪'
  }

  scope :successful, -> { where(success: true, cancelled: false) }

  def request_receipt
    url = Icount.new.generate_receipt(id, icount_label, icount_payment_args)
    if url
      update_attributes(invoice_url: url)
    end
  end

  def self.human_attribute_name(attr, options = {})
    case attr
      when :name
        'שם ושם משפחה'
      when :amount
        'סכום לתשלום'
    end
  end

  private

  def icount_label
    shift.cashdesk.send("#{kind}_label")
  end

  def icount_payment_args
    {
        cc_type:      pelecard.try(:cc_type) || 'מזומן',
        amount:       amount,
        cashamount:   amount,
        payments_num: pelecard.try(:payments_num) || 1,
        totalpaid:    amount
    }
  end
end
