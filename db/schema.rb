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

ActiveRecord::Schema.define(version: 20140809224431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.integer  "shape_id"
    t.float    "lat"
    t.float    "lng"
    t.string   "num"
    t.string   "street"
    t.string   "ward"
    t.string   "mun"
    t.string   "arc"
    t.float    "dist"
    t.string   "lonum"
    t.string   "lonumsuf"
    t.string   "hinum"
    t.string   "hinumsuf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "addresses", ["street"], name: "index_addresses_on_street", using: :btree

  create_table "archives", force: true do |t|
    t.integer  "timestamp",  null: false
    t.string   "filename"
    t.string   "zip"
    t.string   "data"
    t.string   "region"
    t.string   "category"
    t.integer  "filecount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "headstamp"
  end

  add_index "archives", ["timestamp"], name: "index_archives_on_timestamp", unique: true, using: :btree

  create_table "events", force: true do |t|
    t.integer  "venue_id"
    t.integer  "rid"
    t.integer  "iid"
    t.string   "status"
    t.string   "details"
    t.string   "date"
    t.string   "severity"
    t.string   "action"
    t.string   "outcome"
    t.string   "fine"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["iid"], name: "index_events_on_iid", using: :btree

  create_table "grabs", force: true do |t|
    t.string   "category"
    t.string   "path"
    t.text     "url"
    t.boolean  "downloaded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer "version"
  end

  add_index "inspections", ["iid"], name: "index_inspections_on_iid", using: :btree

  create_table "latest_archives", force: true do |t|
    t.string  "category"
    t.integer "headstamp"
  end

  add_index "latest_archives", ["category"], name: "index_latest_archives_on_category", unique: true, using: :btree

  create_table "shapes", force: true do |t|
    t.integer  "timestamp",  null: false
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shapes", ["timestamp"], name: "index_shapes_on_timestamp", unique: true, using: :btree

  create_table "venues", force: true do |t|
    t.integer  "eid"
    t.string   "name"
    t.string   "address"
    t.string   "etype"
    t.float    "lat"
    t.float    "lng"
    t.integer  "mipy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venues", ["eid"], name: "index_venues_on_eid", unique: true, using: :btree

end
