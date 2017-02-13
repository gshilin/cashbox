class CreateCashdesks < ActiveRecord::Migration[5.0]
  def change
    create_table :cashdesks do |t|
      t.integer :number, null: false, unique: true
      t.string :system_name, null: false
      t.string :cc_label, null: false
      t.string :nis_label, null: false
      t.string :eur_label, null: false
      t.string :usd_label, null: false
      t.string :pelecard_ShopNo, null: false
      t.string :icount_email, null: false
      t.timestamps
    end
  end
end
