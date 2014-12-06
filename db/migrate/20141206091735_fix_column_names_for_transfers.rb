class FixColumnNamesForTransfers < ActiveRecord::Migration
  def change
    rename_column :transfers, :From_Account, :from_account_id
    rename_column :transfers, :To_Account, :to_account_id
    rename_column :transfers, :Amount, :amount
  end
end
