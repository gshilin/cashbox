class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :incomes do |t|
      t.float :amount, default: 0.0, null: false # in shekels.agorot
      t.string :kind, null: false # 'cash', 'cc'
      t.string :currency, default: 'ILS', null: false #  ILS – NIS; USD - $; EUR - €
      t.string :name, default: '' # first and last names
      t.boolean :success, default: false, null: false
      t.boolean :cancelled, default: false, null: false
      t.string :invoice_url # url of invoice at icount
      t.belongs_to(:shift, foreign_key: true)

      t.timestamps
    end
  end
end
