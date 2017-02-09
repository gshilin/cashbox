class CreateCreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.string :state
      t.belongs_to(:cashdesk, foreign_key: true)

      t.timestamps
    end
  end
end
