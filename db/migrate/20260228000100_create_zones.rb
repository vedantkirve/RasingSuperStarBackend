class CreateZones < ActiveRecord::Migration[7.0]
  def change
    create_table :zones do |t|
      t.string :name, null: false
      t.text :description
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :zones, :name, unique: true
    add_index :zones, :status
  end
end

