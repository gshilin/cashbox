class AddEmailToCashdesk < ActiveRecord::Migration[5.0]
  def change
    add_column :cashdesks, :icount_email, :string
  end
end
