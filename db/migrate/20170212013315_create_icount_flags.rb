class CreateIcountFlags < ActiveRecord::Migration[5.0]
  def up
    create_table :icount_flags do |t|
      t.boolean :use_icount
    end
    IcountFlag.create use_icount: false
  end

  def down
    drop_table :icount_flags
  end
end
