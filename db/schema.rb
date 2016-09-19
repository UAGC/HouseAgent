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

ActiveRecord::Schema.define(version: 20160919135256) do

  create_table "transactions", force: :cascade do |t|
    t.text    "district"
    t.integer "rcount"
    t.integer "total_area"
    t.integer "resident_area"
    t.text    "trx_type"
    t.text    "created_at",    null: false
    t.text    "updated_at",    null: false
    t.date    "trx_date"
  end

end