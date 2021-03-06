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

ActiveRecord::Schema.define(:version => 20130402145318) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.integer  "balance_cents",    :default => 0,     :null => false
    t.string   "balance_currency", :default => "USD", :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "envelopes", :force => true do |t|
    t.string   "name"
    t.integer  "balance_cents",    :default => 0,     :null => false
    t.string   "balance_currency", :default => "USD", :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "income",           :default => false
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "statements", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "start_balance_cents"
    t.integer  "end_balance_cents"
    t.integer  "account_id"
    t.boolean  "reconciled",              :default => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.string   "payee"
    t.integer  "amount_cents",                                       :null => false
    t.string   "amount_currency",                :default => "USD",  :null => false
    t.integer  "account_id"
    t.integer  "envelope_id"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.date     "entry_date",                                         :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "memo"
    t.integer  "current_account_balance_cents",  :default => 0
    t.integer  "current_envelope_balance_cents", :default => 0
    t.string   "status",                         :default => "open"
    t.integer  "statement_id"
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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
