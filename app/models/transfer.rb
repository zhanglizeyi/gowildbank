class Transfer < ActiveRecord::Base
	belongs_to :bank_accounts
	belongs_to :user
end
