# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160310143154) do

  create_table "book_infos", force: :cascade do |t|
    t.string   "isbn"
    t.string   "name"
    t.string   "cover"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "source"
    t.string   "author"
  end

  create_table "books", force: :cascade do |t|
    t.integer  "book_info_id"
    t.integer  "user_id"
    t.integer  "number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "recorder_id"
  end

  add_index "books", ["book_info_id"], name: "index_books_on_book_info_id"
  add_index "books", ["recorder_id"], name: "index_books_on_recorder_id"
  add_index "books", ["user_id"], name: "index_books_on_user_id"

  create_table "user_favor_books", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_info_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_favor_books", ["book_info_id"], name: "index_user_favor_books_on_book_info_id"
  add_index "user_favor_books", ["user_id"], name: "index_user_favor_books_on_user_id"

  create_table "user_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "value"
    t.integer  "time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "target_path"
  end

  add_index "user_tokens", ["user_id"], name: "index_user_tokens_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "account",         null: false
    t.string   "name"
    t.string   "nickname"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["account"], name: "index_users_on_account"

end
