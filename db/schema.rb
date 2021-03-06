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

ActiveRecord::Schema.define(version: 20160923100322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "key"
    t.text     "parameters"
    t.boolean  "seen",           default: false
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "attachinary_files", force: :cascade do |t|
    t.string   "attachinariable_type"
    t.integer  "attachinariable_id"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree
  end

  create_table "attendees", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "meeting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_id"], name: "index_attendees_on_meeting_id", using: :btree
    t.index ["user_id"], name: "index_attendees_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "topic_id"
    t.string   "github_id"
    t.boolean  "pinned"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "content"
    t.index ["topic_id"], name: "index_comments_on_topic_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "meetings", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "object"
    t.string   "state"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_meetings_on_project_id", using: :btree
  end

  create_table "mentions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_mentions_on_comment_id", using: :btree
    t.index ["user_id"], name: "index_mentions_on_user_id", using: :btree
  end

  create_table "order_lines", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "order_id"
    t.integer  "unit_price"
    t.integer  "duration"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["order_id"], name: "index_order_lines_on_order_id", using: :btree
    t.index ["project_id"], name: "index_order_lines_on_project_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "state"
    t.date     "due_date"
    t.integer  "price"
    t.integer  "quantity"
    t.string   "integer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "review"
    t.integer  "rating"
  end

  create_table "project_transitions", force: :cascade do |t|
    t.string   "to_state",                   null: false
    t.text     "metadata",    default: "{}"
    t.integer  "sort_key",                   null: false
    t.integer  "project_id",                 null: false
    t.boolean  "most_recent",                null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["project_id", "most_recent"], name: "index_project_transitions_parent_most_recent", unique: true, where: "most_recent", using: :btree
    t.index ["project_id", "sort_key"], name: "index_project_transitions_parent_sort", unique: true, using: :btree
  end

  create_table "project_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id", using: :btree
    t.index ["user_id"], name: "index_project_users_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "part_functionality"
    t.text     "notes"
    t.string   "measurement_unit"
    t.decimal  "length"
    t.decimal  "width"
    t.decimal  "height"
    t.decimal  "min_wall_thickness"
    t.decimal  "min_hole_diameter"
    t.decimal  "max_pipe_diameter"
    t.boolean  "impossible_details"
    t.boolean  "trapped_volumes"
    t.string   "repo_id"
    t.string   "thales_id"
    t.string   "client_project_id"
    t.string   "client"
    t.string   "state"
    t.string   "cycle"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "github_owner"
    t.date     "due_date"
  end

  create_table "specs", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.text     "description"
    t.boolean  "standard"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "ancestry"
    t.index ["ancestry"], name: "index_specs_on_ancestry", using: :btree
    t.index ["project_id"], name: "index_specs_on_project_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "type"
    t.integer  "github_number"
    t.string   "state"
    t.string   "category"
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "project_state"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["project_id"], name: "index_topics_on_project_id", using: :btree
    t.index ["user_id"], name: "index_topics_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "token"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "picture"
    t.string   "category"
    t.string   "entity"
    t.string   "github_login"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "attendees", "meetings"
  add_foreign_key "attendees", "users"
  add_foreign_key "comments", "topics"
  add_foreign_key "comments", "users"
  add_foreign_key "meetings", "projects"
  add_foreign_key "mentions", "comments"
  add_foreign_key "mentions", "users"
  add_foreign_key "order_lines", "orders"
  add_foreign_key "order_lines", "projects"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "specs", "projects"
  add_foreign_key "topics", "projects"
  add_foreign_key "topics", "users"
end
