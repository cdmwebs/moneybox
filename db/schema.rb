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

ActiveRecord::Schema.define(:version => 20130203225517) do

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

  create_table "transactions", :force => true do |t|
    t.string   "payee"
    t.integer  "amount_cents",    :default => 0,            :null => false
    t.string   "amount_currency", :default => "USD",        :null => false
    t.integer  "account_id"
    t.integer  "envelope_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.date     "entry_date",      :default => '2013-02-03', :null => false
  end

end
