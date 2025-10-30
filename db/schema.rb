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

ActiveRecord::Schema[8.1].define(version: 2022_11_15_155146) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", limit: 100
    t.string "first_name", limit: 50
    t.string "last_name", limit: 50
    t.datetime "updated_at", null: false
  end

  create_table "contents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "markdown"
    t.string "name", limit: 20
    t.datetime "updated_at", null: false
  end

  create_table "exhibits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "link"
    t.string "location", limit: 40
    t.string "name", limit: 40
    t.integer "paintings_count", limit: 2, default: 0
    t.boolean "previous", default: false
    t.datetime "updated_at", null: false
  end

  create_table "paintings", force: :cascade do |t|
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.bigint "exhibit_id"
    t.integer "gallery", limit: 2
    t.integer "height", limit: 2
    t.integer "image_height", limit: 2
    t.integer "image_width", limit: 2
    t.string "media", limit: 5
    t.text "note"
    t.integer "price", limit: 2
    t.integer "print", limit: 2
    t.boolean "sale", default: false
    t.boolean "sold", default: false
    t.integer "stars", limit: 2
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "version", limit: 2, default: 0
    t.integer "width", limit: 2
    t.index ["exhibit_id"], name: "index_paintings_on_exhibit_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.integer "last_otp_at"
    t.string "name"
    t.boolean "otp_required", default: false
    t.string "otp_secret", limit: 32
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end
end
