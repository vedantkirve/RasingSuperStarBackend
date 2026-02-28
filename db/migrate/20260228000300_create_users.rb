class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone_number
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :users, :email
    add_index :users, :status
  end
end

