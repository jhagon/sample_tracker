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

ActiveRecord::Schema.define(:version => 20140913173354) do

  create_table "assets", :force => true do |t|
    t.string   "document"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flags", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "group_abbr", :limit => 3
    t.string   "group_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hazards", :force => true do |t|
    t.string   "hazard_desc"
    t.string   "hazard_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hazards_samples", :id => false, :force => true do |t|
    t.integer "sample_id", :null => false
    t.integer "hazard_id", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "menu"
    t.integer  "priority",   :default => 1
  end

  create_table "popups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", :force => true do |t|
    t.string   "code"
    t.string   "cif"
    t.string   "synth"
    t.string   "coshh_name"
    t.string   "coshh_desc"
    t.text     "coshh_info"
    t.string   "params"
    t.integer  "priority"
    t.boolean  "powd"
    t.boolean  "chiral"
    t.string   "cost_code"
    t.string   "barcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "flag_id",     :default => 1, :null => false
    t.string   "userref"
    t.string   "zipdata"
    t.string   "sampleimage"
    t.string   "reference"
    t.text     "comments"
    t.text     "colour"
    t.text     "size"
    t.text     "shape"
    t.text     "feedback"
    t.text     "spec_info"
  end

  create_table "samples_sensitivities", :id => false, :force => true do |t|
    t.integer "sample_id",      :null => false
    t.integer "sensitivity_id", :null => false
  end

  create_table "samples_stores", :id => false, :force => true do |t|
    t.integer "sample_id", :null => false
    t.integer "store_id",  :null => false
  end

  create_table "sensitivities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", :force => true do |t|
    t.string   "name"
    t.text     "comment"
    t.string   "content_type"
    t.binary   "data",         :limit => 2097152
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.boolean  "admin",                                 :default => false
    t.string   "firstname"
    t.string   "lastname"
    t.boolean  "leader",                                :default => false
    t.boolean  "enabled",                               :default => true
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
