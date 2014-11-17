class AddBalanceInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :debit, :float
    add_column :users, :credit, :float
  end
end
