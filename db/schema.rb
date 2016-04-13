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

ActiveRecord::Schema.define(version: 20160410162502) do

  create_table "accounts", force: true do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "stripe_user_id"
    t.string   "stripe_publishable_key"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["user_id", "created_at"], name: "index_accounts_on_user_id_and_created_at"
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id"

  create_table "attendees", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "message"
    t.boolean  "attending"
    t.integer  "event_id"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buyers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.text     "description",    limit: 255
    t.string   "location"
    t.string   "background_img"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
    t.string   "date_start"
    t.string   "time_start"
    t.string   "date_end"
    t.string   "time_end"
    t.string   "layout_id"
    t.string   "layout_style"
    t.boolean  "show_custom"
    t.boolean  "published",                  default: false
    t.string   "location_name"
    t.string   "subdomain"
    t.string   "slug"
    t.string   "host_name"
    t.string   "bg_opacity"
    t.string   "bg_color"
    t.string   "font_type"
    t.string   "external_image"
    t.boolean  "status",                     default: true
  end

  add_index "events", ["slug"], name: "index_events_on_slug", unique: true

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "line_item", id: false, force: true do |t|
    t.integer "ticket_id",   null: false
    t.integer "attendee_id", null: false
  end

  add_index "line_item", ["attendee_id"], name: "index_line_item_on_attendee_id"
  add_index "line_item", ["ticket_id"], name: "index_line_item_on_ticket_id"

  create_table "line_items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.string   "ticket_id"
    t.string   "attendee_id"
    t.string   "purchase_id"
  end

  create_table "purchases", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "line_item_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "stripe_id"
    t.integer  "event_id"
  end

  add_index "purchases", ["event_id"], name: "index_purchases_on_event_id"

  create_table "reservation", id: false, force: true do |t|
    t.integer "event_id",    null: false
    t.integer "attendee_id", null: false
  end

  add_index "reservation", ["attendee_id"], name: "index_reservation_on_attendee_id"
  add_index "reservation", ["event_id"], name: "index_reservation_on_event_id"

  create_table "themes", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "font_type"
    t.string   "bg_opacity"
    t.string   "bg_color"
    t.string   "layout_type"
    t.string   "icon"
  end

  create_table "tickets", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "price"
    t.integer  "ticket_limit"
    t.integer  "buy_limit",    default: 4
    t.date     "stop_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "event_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "premium",                default: false
    t.string   "customer_id"
    t.string   "plan_type"
    t.string   "subscription_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
