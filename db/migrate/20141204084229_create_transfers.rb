class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.string :From_account
      t.string :To_Account
      t.decimal :Amount

      t.timestamps
    end
  end
end
