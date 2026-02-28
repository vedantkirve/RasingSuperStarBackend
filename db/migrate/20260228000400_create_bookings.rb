class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :coach, null: false, foreign_key: true, index: true
      t.date :session_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :state
      t.string :status, null: false, default: "active"
      t.text :cancellation_reason

      t.timestamps
    end

    add_index :bookings, [:coach_id, :session_date]
    add_index :bookings, [:coach_id, :session_date, :start_time], unique: true
  end
end

