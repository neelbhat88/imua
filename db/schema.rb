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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130916194626) do

  create_table "donors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "global_badges", :force => true do |t|
    t.string   "title"
    t.string   "category"
    t.integer  "semester"
    t.boolean  "isminrequirement"
    t.text     "description"
    t.integer  "subcategory"
    t.string   "comparevalue"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "badge_value",      :default => 0
  end

  create_table "global_exams", :force => true do |t|
    t.string   "name"
    t.string   "exam_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "school_activities", :force => true do |t|
    t.integer  "school_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "school_classes", :force => true do |t|
    t.integer  "school_id"
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.float    "credit_hours", :default => 1.0
  end

  create_table "school_pdus", :force => true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_activities", :force => true do |t|
    t.integer  "school_activity_id"
    t.boolean  "leadership_held"
    t.string   "leadership_title"
    t.text     "description"
    t.integer  "semester"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "user_badges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "global_badge_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "semester"
  end

  create_table "user_classes", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "level"
    t.string   "grade"
    t.float    "gpa"
    t.integer  "semester"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "school_class_id", :default => 3
  end

  create_table "user_infos", :force => true do |t|
    t.integer  "current_semester",            :default => 1
    t.integer  "school_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "user_id"
    t.text     "big_goal"
    t.text     "why_description"
    t.text     "how_description"
    t.string   "college_avatar_file_name"
    t.string   "college_avatar_content_type"
    t.integer  "college_avatar_file_size"
    t.datetime "college_avatar_updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "classof"
  end

  create_table "user_pdus", :force => true do |t|
    t.integer  "user_id"
    t.integer  "semester"
    t.integer  "hours"
    t.datetime "date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "school_pdu_id"
  end

  create_table "user_semester_gpas", :force => true do |t|
    t.integer  "user_id"
    t.integer  "semester"
    t.decimal  "gpa"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_services", :force => true do |t|
    t.integer  "user_id"
    t.integer  "semester"
    t.string   "name"
    t.float    "hours"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_testings", :force => true do |t|
    t.integer  "global_exam_id"
    t.integer  "user_id"
    t.integer  "semester"
    t.date     "date"
    t.integer  "score"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "role",                   :default => 0
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
