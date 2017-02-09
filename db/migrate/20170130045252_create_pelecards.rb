class CreatePelecards < ActiveRecord::Migration[5.0]
  def change
    create_table :pelecards do |t|
      t.string :confirmation_key
      t.string :user_key
      t.string :transaction_id
      t.integer :status_code
      t.integer :cashdesk
      t.integer :shift
      t.string :approval_no
      t.string :shva_result
      t.string :voucher_id
      t.string :transaction_pelecard_id
      t.string :shva_file_number
      t.string :station_number
      t.string :receipt
      t.string :j_param
      t.string :cc_number
      t.string :cc_exp_date
      t.string :cc_company_clearer
      t.string :cc_company_issuer
      t.string :credit_type
      t.string :cc_abroad_card
      t.string :debit_type
      t.string :debit_code
      t.string :debit_total
      t.string :debit_currency
      t.string :total_payments
      t.string :first_payment_total
      t.string :fixed_payment_total
      t.string :cc_brand
      t.string :cc_hebrew_name
      t.string :shva_output
      t.string :approved_by
      t.string :transaction_init_time
      t.string :transaction_update_time

      t.belongs_to(:income, foreign_key: true)
      t.timestamps
    end
  end
end
