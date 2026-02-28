class CreateCoaches < ActiveRecord::Migration[7.0]
  def change
    create_table :coaches do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone_number
      t.references :zone, null: false, foreign_key: true, index: true
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :coaches, :status
  end
end

