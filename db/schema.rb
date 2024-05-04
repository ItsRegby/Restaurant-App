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

ActiveRecord::Schema[7.1].define(version: 2024_04_30_220001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "user_role", ["admin", "customer"]

  create_table "categories", primary_key: "category_id", id: :serial, force: :cascade do |t|
    t.string "category_name", limit: 255, null: false
    t.binary "image"
  end

  create_table "menu", primary_key: "item_id", id: :serial, force: :cascade do |t|
    t.string "item_name", limit: 255, null: false
    t.text "description"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "category_id", null: false
    t.boolean "can_be_prepared", null: false
    t.binary "image"
    t.index ["category_id"], name: "1"
  end

  create_table "orders", primary_key: "order_id", id: :serial, force: :cascade do |t|
    t.string "user_id", limit: 255, null: false
    t.jsonb "added_items_data", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.datetime "order_date", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "status", limit: 50
  end

  create_table "reviews", primary_key: "review_id", id: :serial, force: :cascade do |t|
    t.string "user_id", limit: 255, null: false
    t.text "review_text"
    t.integer "rating", null: false
    t.datetime "review_date", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.check_constraint "rating >= 1 AND rating <= 5", name: "reviews_rating_check"
  end

  create_table "user_profiles", primary_key: "profile_id", id: :serial, force: :cascade do |t|
    t.string "user_id", limit: 255, null: false
    t.string "full_name", limit: 255, null: false
    t.text "address"
    t.string "phone_number", limit: 15

    t.unique_constraint ["user_id"], name: "user_profiles_user_id_key"
  end

  create_table "users", primary_key: "user_id", id: { type: :string, limit: 255 }, force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.enum "role", null: false, enum_type: "user_role"
    t.string "password_digest"

    t.unique_constraint ["email"], name: "users_email_key"
  end

  add_foreign_key "menu", "categories", primary_key: "category_id", name: "menu_category_id_fkey", on_delete: :cascade, validate: false
  add_foreign_key "orders", "users", primary_key: "user_id", name: "orders_user_id_fkey"
  add_foreign_key "reviews", "users", primary_key: "user_id", name: "reviews_user_id_fkey", validate: false
  add_foreign_key "user_profiles", "users", primary_key: "user_id", name: "user_profiles_user_id_fkey", validate: false
end
