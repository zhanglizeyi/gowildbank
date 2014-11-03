class Dispaly < ActiveRecord::Base
	validates :username,length: {maximum: 15}
	validates :username, length: {minimum: 4}
	validates :username, :presence => true, :uniqueness => true
	validates :password, length: {maximum: 15}
	validates :password, length: {minimum: 4}
	validates :password, :presence => true, :uniqueness => true
end
