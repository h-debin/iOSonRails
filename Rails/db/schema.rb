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

ActiveRecord::Schema.define(version: 20150329070237) do

  create_table "news", force: true do |t|
    t.text     "title"
    t.text     "description"
    t.text     "guid"
    t.datetime "pub_date"
    t.text     "link"
    t.text     "category"
    t.text     "picture"
    t.integer  "le"
    t.integer  "hao"
    t.integer  "nu"
    t.integer  "ai"
    t.integer  "ju"
    t.integer  "e"
    t.integer  "jing"
    t.time     "created_at"
    t.time     "updated_at"
    t.text     "emotion_type"
    t.integer  "main_emotion_value"
  end

  create_table "users", force: true do |t|
    t.text     "device_uuid"
    t.text     "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
