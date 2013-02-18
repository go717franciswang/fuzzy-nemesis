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

ActiveRecord::Schema.define(:version => 20130218001410) do

  create_table "annuity_freq_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "historical_prices", :force => true do |t|
    t.integer  "stock_id"
    t.date     "date_at"
    t.float    "high"
    t.float    "low"
    t.float    "open"
    t.float    "close"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "volume"
    t.float    "adj_close"
  end

  add_index "historical_prices", ["stock_id", "date_at"], :name => "index_historical_prices_on_stock_id_and_date_at", :unique => true

  create_table "scenarios", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "simulation_logs", :force => true do |t|
    t.integer  "simulation_id"
    t.date     "date_at"
    t.float    "fund"
    t.integer  "share"
    t.float    "net_value"
    t.string   "event"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "simulation_scenarios", :force => true do |t|
    t.integer  "simulation_id"
    t.integer  "scenario_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "simulations", :force => true do |t|
    t.integer  "stock_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.float    "start_amount"
    t.float    "annuity"
    t.integer  "annuity_freq_type_id"
    t.integer  "start_shares"
  end

  create_table "stocks", :force => true do |t|
    t.string   "name"
    t.string   "quote"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "sector"
    t.string   "industry"
    t.integer  "full_time_employees"
    t.datetime "refreshed_at"
  end

  add_index "stocks", ["quote"], :name => "index_stocks_on_quote", :unique => true

end
