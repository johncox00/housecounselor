# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_01_092355) do

  create_table "addresses", force: :cascade do |t|
    t.string "line1"
    t.string "line2"
    t.integer "city_id", null: false
    t.integer "state_id", null: false
    t.integer "postal_code_id", null: false
    t.string "addressable_type", null: false
    t.integer "addressable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["postal_code_id"], name: "index_addresses_on_postal_code_id"
    t.index ["state_id"], name: "index_addresses_on_state_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.float "avg_rating", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "state_id", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "city_postal_codes", force: :cascade do |t|
    t.integer "city_id", null: false
    t.integer "postal_code_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_city_postal_codes_on_city_id"
    t.index ["postal_code_id"], name: "index_city_postal_codes_on_postal_code_id"
  end

  create_table "postal_codes", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating", default: 0, null: false
    t.string "comment"
    t.integer "business_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_reviews_on_business_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "abbr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "postal_codes"
  add_foreign_key "addresses", "states"
  add_foreign_key "cities", "states"
  add_foreign_key "city_postal_codes", "cities"
  add_foreign_key "city_postal_codes", "postal_codes"
  add_foreign_key "reviews", "businesses"
end
