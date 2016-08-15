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

ActiveRecord::Schema.define(version: 20160815204235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "job_applications", force: :cascade do |t|
    t.string   "user_name"
    t.string   "user_email"
    t.string   "user_phone_number"
    t.string   "user_resume_path"
    t.string   "user_cover_letter"
    t.string   "indeed_link"
    t.string   "title"
    t.string   "company"
    t.string   "location"
    t.string   "pay_rate"
    t.boolean  "applied_to",        default: false
    t.integer  "pay_type"
    t.text     "description"
    t.integer  "job_link_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "should_apply",      default: true
  end

  add_index "job_applications", ["job_link_id"], name: "index_job_applications_on_job_link_id", using: :btree

  create_table "job_links", force: :cascade do |t|
    t.string   "job_title"
    t.string   "job_type"
    t.string   "job_subtitles"
    t.string   "job_location"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "job_links", ["user_id"], name: "index_job_links_on_user_id", using: :btree

  create_table "recruiters", force: :cascade do |t|
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
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "recruiters", ["email"], name: "index_recruiters_on_email", unique: true, using: :btree
  add_index "recruiters", ["reset_password_token"], name: "index_recruiters_on_reset_password_token", unique: true, using: :btree

  create_table "referral_codes", force: :cascade do |t|
    t.integer  "recruiter_id"
    t.integer  "user_id"
    t.string   "code"
    t.integer  "number_of_users"
    t.integer  "paid_user_uses"
    t.integer  "number_of_recruiters"
    t.integer  "paid_recruiter_uses"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "referral_codes", ["recruiter_id"], name: "index_referral_codes_on_recruiter_id", using: :btree
  add_index "referral_codes", ["user_id"], name: "index_referral_codes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "phone_number"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.text     "cover_letter"
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
    t.string   "resume_file_name",                    null: false
    t.string   "resume_content_type",                 null: false
    t.integer  "resume_file_size",                    null: false
    t.datetime "resume_updated_at",                   null: false
    t.integer  "credits",                default: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
