class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.string :From_Account
      t.string :To_Account
      t.decimal :Amount

      t.belongs_to :bank_accounts
      t.timestamps
    end
  end
end
