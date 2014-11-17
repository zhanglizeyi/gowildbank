class CreateDispalies < ActiveRecord::Migration
  def change
    create_table :dispalies do |t|
      t.string :username
      t.string :password
      t.boolean :remember
      t.date :date
      t.string :DOB

      t.timestamps null:false
    end
  end
end
