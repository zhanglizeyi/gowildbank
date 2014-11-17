class FixAccountTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :bank_accounts, :accout_type, :account_type
  end
end
