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

ActiveRecord::Schema.define(version: 20131208115005) do

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "comment"
    t.integer  "user_id"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["entry_id"], name: "index_comments_on_entry_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "entries", force: true do |t|
    t.string   "topic"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "report_abuse"
    t.integer  "movie_id"
  end

  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "like_entries", force: true do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  add_index "like_entries", ["entry_id"], name: "index_like_entries_on_entry_id", using: :btree
  add_index "like_entries", ["user_id"], name: "index_like_entries_on_user_id", using: :btree

  create_table "like_movies", force: true do |t|
    t.integer  "user_id"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "like_movies", ["movie_id"], name: "index_like_movies_on_movie_id", using: :btree
  add_index "like_movies", ["user_id"], name: "index_like_movies_on_user_id", using: :btree

  create_table "movies", force: true do |t|
    t.string   "my_id"
    t.string   "title"
    t.string   "backdrop_path"
    t.string   "release_date"
    t.string   "poster_path"
    t.string   "vote_average"
    t.string   "adult"
    t.text     "overview"
    t.string   "trailer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotations", force: true do |t|
    t.string   "author_name"
    t.string   "category"
    t.text     "quote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redactor_assets", force: true do |t|
    t.integer  "user_id"
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], name: "idx_redactor_assetable", using: :btree
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.text     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "solutions", force: true do |t|
    t.string   "name"
    t.string   "explanation"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "solutions", ["project_id"], name: "index_solutions_on_project_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "role_id",                default: 2
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
