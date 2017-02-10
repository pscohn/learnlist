# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170210015539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "list_items", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "index"
    t.integer  "list_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["list_id"], name: "index_list_items_on_list_id", using: :btree
  end

  create_table "list_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.string   "state",      default: "todo", null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "saved",      default: false
    t.index ["list_id"], name: "index_list_users_on_list_id", using: :btree
    t.index ["user_id"], name: "index_list_users_on_user_id", using: :btree
  end

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "category"
    t.string   "state",       default: "draft", null: false
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["user_id"], name: "index_lists_on_user_id", using: :btree
  end

  create_table "user_checks", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.integer  "list_item_id",                 null: false
    t.boolean  "completed",    default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["list_item_id"], name: "index_user_checks_on_list_item_id", using: :btree
    t.index ["user_id"], name: "index_user_checks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "user_checks", "list_items"
  add_foreign_key "user_checks", "users"
end
