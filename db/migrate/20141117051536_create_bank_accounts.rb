class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :accout_type
      t.float :balance
      t.string :label

      t.belongs_to :user
      t.timestamps
    end

    remove_column :users, :debit
    remove_column :users, :credit

  end
end
