class AddBalanceInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :debit, :decimal
    add_column :users, :credit, :decimal
  end
end
