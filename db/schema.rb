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

ActiveRecord::Schema.define(version: 20140721200037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archives", force: true do |t|
    t.integer  "timestamp",  null: false
    t.string   "filename"
    t.string   "fullpath"
    t.string   "region"
    t.string   "subregion"
    t.boolean  "fresh"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "archives", ["timestamp"], name: "index_archives_on_timestamp", unique: true, using: :btree

  create_table "inspections", force: true do |t|
    t.integer "rid"
    t.integer "eid"
    t.integer "iid"
    t.string  "name"
    t.string  "etype"
    t.string  "status"
    t.string  "details"
    t.string  "date"
    t.string  "severity"
    t.string  "action"
    t.string  "outcome"
    t.string  "fine"
    t.string  "address"
    t.integer "mipy"
  end

  add_index "inspections", ["iid"], name: "index_inspections_on_iid", using: :btree

end
