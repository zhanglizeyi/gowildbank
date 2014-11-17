# coding: utf-8
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username， null: false
      t.string :email， null: false
      t.string :encrypted_password， null: false
      t.string :salt， null: false
      t.timestamps
    end
  end

  say "create a table"
end
