class User < ActiveRecord::Base
  #validates :username,length: {maximum: 25}
  #validates :username, length: {minimum: 4}
  #validates :username, :presence => true, :uniqueness => true, if: "username.nil?"
  #validates :salt, length: {maximum: 25}
  #validates :salt	, length: {minimum: 6}
  #validates :salt, :presence => true, :uniqueness => true 
  #validates :email, length: {maximum: 25}
  #validates :email, length: {minimum: 4}
  #validates :email, :presence => true, :uniqueness => true
  #validates :username, :salt, :email, presence: true
  #attr_accessor :username
  has_many :bank_accounts, dependent: :destroy
  has_many :transfers
end

