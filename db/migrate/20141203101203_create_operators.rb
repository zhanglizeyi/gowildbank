class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
      t.string :username
      t.string :label
      t.decimal :amount
      t.decimal :transfer

      t.timestamps
    end
  end
end
