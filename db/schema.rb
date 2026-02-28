# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_28_000400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.text "cancellation_reason"
    t.bigint "coach_id", null: false
    t.datetime "created_at", null: false
    t.time "end_time", null: false
    t.date "session_date", null: false
    t.time "start_time", null: false
    t.string "state"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["coach_id", "session_date", "start_time"], name: "index_bookings_on_coach_id_and_session_date_and_start_time", unique: true
    t.index ["coach_id", "session_date"], name: "index_bookings_on_coach_id_and_session_date"
    t.index ["coach_id"], name: "index_bookings_on_coach_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "coaches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.time "end_time", null: false
    t.string "name", null: false
    t.string "phone_number"
    t.time "start_time", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.bigint "zone_id", null: false
    t.index ["status"], name: "index_coaches_on_status"
    t.index ["zone_id"], name: "index_coaches_on_zone_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.string "phone_number"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["status"], name: "index_users_on_status"
  end

  create_table "zones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_zones_on_name", unique: true
    t.index ["status"], name: "index_zones_on_status"
  end

  add_foreign_key "bookings", "coaches"
  add_foreign_key "bookings", "users"
  add_foreign_key "coaches", "zones"
end
