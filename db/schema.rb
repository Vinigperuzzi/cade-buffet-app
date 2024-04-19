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

ActiveRecord::Schema[7.1].define(version: 2024_04_19_133230) do
  create_table "buffets", force: :cascade do |t|
    t.string "name"
    t.string "corporate_name"
    t.string "register_number"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "district"
    t.string "state"
    t.string "city"
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "min_qtd"
    t.integer "max_qtd"
    t.integer "duration"
    t.string "menu"
    t.boolean "drinks"
    t.boolean "decoration"
    t.boolean "valet"
    t.integer "buffet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "only_local"
    t.index ["buffet_id"], name: "index_events_on_buffet_id"
  end

  create_table "prices", force: :cascade do |t|
    t.integer "base_price"
    t.integer "additional_person"
    t.integer "extra_hour"
    t.integer "sp_base_price"
    t.integer "sp_additional_person"
    t.integer "sp_extra_hour"
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_prices_on_event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "buffet_id"
    t.index ["buffet_id"], name: "index_users_on_buffet_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "events", "buffets"
  add_foreign_key "prices", "events"
  add_foreign_key "users", "buffets"
end
