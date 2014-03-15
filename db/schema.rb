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

ActiveRecord::Schema.define(:version => 20140315162155) do

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

  create_table "global_practice_test_answers", :force => true do |t|
    t.integer  "global_practice_test_question_id"
    t.string   "answer_text"
    t.boolean  "is_correct"
    t.integer  "position"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "global_practice_test_questions", :force => true do |t|
    t.integer  "global_practice_test_id"
    t.integer  "number"
    t.text     "question_text"
    t.string   "solution_url"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "global_practice_tests", :force => true do |t|
    t.string   "name"
    t.integer  "semester"
    t.string   "section"
    t.string   "subject"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "school_activities", :force => true do |t|
    t.integer  "school_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "school_activities", ["school_id"], :name => "IDX_SchoolActivity_SchoolId"

  create_table "school_classes", :force => true do |t|
    t.integer  "school_id"
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.float    "credit_hours", :default => 1.0
  end

  add_index "school_classes", ["school_id"], :name => "IDX_SchoolClass_SchoolId"

  create_table "school_pdus", :force => true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "school_pdus", ["school_id"], :name => "IDX_SchoolPdu_SchoolId"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "test_prep_categories", :force => true do |t|
    t.integer  "test_prep_subject_id"
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "test_prep_categories", ["test_prep_subject_id"], :name => "IDX_TestPrepCategory_TestPrepSubject"

  create_table "test_prep_sub_categories", :force => true do |t|
    t.integer  "test_prep_category_id"
    t.string   "name"
    t.text     "description"
    t.integer  "level"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "test_prep_sub_categories", ["test_prep_category_id"], :name => "IDX_TestPrepSubCategory_TestPrepCategory"

  create_table "test_prep_subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "to_do_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assigned_by_id"
    t.string   "description"
    t.datetime "date_due"
    t.boolean  "completed"
    t.datetime "date_complete"
    t.boolean  "verified"
    t.datetime "date_verified"
    t.text     "notes"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "to_do_items", ["user_id"], :name => "IDX_ToDoItem_UserId"

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

  add_index "user_activities", ["school_activity_id"], :name => "IDX_UserActivity_SchoolActivityId"
  add_index "user_activities", ["user_id"], :name => "IDX_UserActivity_UserId"

  create_table "user_badges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "global_badge_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "semester"
  end

  add_index "user_badges", ["global_badge_id"], :name => "IDX_UserBadge_GlobalBadgeId"
  add_index "user_badges", ["user_id"], :name => "IDX_UserBadge_UserId"

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

  add_index "user_classes", ["school_class_id"], :name => "IDX_UserClass_SchoolClassId"
  add_index "user_classes", ["user_id"], :name => "IDX_UserClass_UserId"

  create_table "user_deductions", :force => true do |t|
    t.integer  "user_id"
    t.string   "deduction_type"
    t.integer  "deduction_level"
    t.integer  "deduction_value"
    t.string   "deduction_details"
    t.integer  "semester"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "user_deductions", ["user_id"], :name => "IDX_UserDeductions_UserId"

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
    t.string   "phone"
  end

  add_index "user_infos", ["school_id"], :name => "IDX_UserInfo_SchoolId"
  add_index "user_infos", ["user_id"], :name => "IDX_UserInfo_UserId"

  create_table "user_pdus", :force => true do |t|
    t.integer  "user_id"
    t.integer  "semester"
    t.decimal  "hours"
    t.datetime "date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "school_pdu_id"
  end

  add_index "user_pdus", ["school_pdu_id"], :name => "IDX_UserPdu_SchoolPduId"
  add_index "user_pdus", ["user_id"], :name => "IDX_UserPdu_UserId"

  create_table "user_practice_tests", :force => true do |t|
    t.integer  "global_practice_test_id"
    t.decimal  "score"
    t.integer  "user_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "semester"
  end

  create_table "user_semester_gpas", :force => true do |t|
    t.integer  "user_id"
    t.integer  "semester"
    t.decimal  "gpa"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_semester_gpas", ["user_id"], :name => "IDX_UserSemsterGpa_UserId"

  create_table "user_services", :force => true do |t|
    t.integer  "user_id"
    t.integer  "semester"
    t.string   "name"
    t.float    "hours"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_services", ["user_id"], :name => "IDX_UserService_UserId"

  create_table "user_testings", :force => true do |t|
    t.integer  "global_exam_id"
    t.integer  "user_id"
    t.integer  "semester"
    t.date     "date"
    t.decimal  "score"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "user_testings", ["global_exam_id"], :name => "IDX_UserTesting_GlobalExamId"
  add_index "user_testings", ["user_id"], :name => "IDX_UserTesting_UserId"

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
