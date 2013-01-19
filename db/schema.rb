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

ActiveRecord::Schema.define(:version => 20130118075036) do

  create_table "historical_prices", :force => true do |t|
    t.integer  "stock_id"
    t.date     "date_at"
    t.float    "high"
    t.float    "low"
    t.float    "open"
    t.float    "close"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "historical_prices", ["stock_id", "date_at"], :name => "index_historical_prices_on_stock_id_and_date_at", :unique => true

  create_table "stocks", :force => true do |t|
    t.string   "name"
    t.string   "quote"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stocks", ["quote"], :name => "index_stocks_on_quote", :unique => true

end
