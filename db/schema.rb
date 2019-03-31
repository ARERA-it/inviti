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

ActiveRecord::Schema.define(version: 2019_03_28_221221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accepts", force: :cascade do |t|
    t.string "token"
    t.bigint "invitation_id"
    t.bigint "user_id"
    t.integer "decision", default: 0
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_id"], name: "index_accepts_on_invitation_id"
    t.index ["user_id"], name: "index_accepts_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "invitation_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_id"], name: "index_comments_on_invitation_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "invitation_id"
    t.bigint "user_id"
    t.string "title"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_id"], name: "index_contributions_on_invitation_id"
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log"
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "invitations", force: :cascade do |t|
    t.string "title"
    t.string "location"
    t.datetime "from_date_and_time"
    t.datetime "to_date_and_time"
    t.string "organizer"
    t.text "notes"
    t.string "email_id"
    t.string "email_from_name"
    t.string "email_from_address"
    t.string "email_subject"
    t.string "email_body_preview"
    t.text "email_body"
    t.datetime "email_received_date_time"
    t.boolean "has_attachments"
    t.string "attachments"
    t.integer "appointee_id"
    t.string "alt_appointee_name"
    t.text "delegation_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "decision", default: 0
    t.boolean "need_info", default: true
    t.boolean "opinion_expressed", default: false
    t.boolean "expired", default: false
    t.integer "state", default: 0
    t.string "appointee_message"
    t.index ["appointee_id"], name: "index_invitations_on_appointee_id"
    t.index ["email_received_date_time"], name: "index_invitations_on_email_received_date_time"
    t.index ["from_date_and_time"], name: "index_invitations_on_from_date_and_time"
  end

  create_table "invitations_users", id: false, force: :cascade do |t|
    t.bigint "invitation_id"
    t.bigint "user_id"
    t.index ["invitation_id"], name: "index_invitations_users_on_invitation_id"
    t.index ["user_id"], name: "index_invitations_users_on_user_id"
  end

  create_table "opinions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "invitation_id"
    t.integer "selection", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_id"], name: "index_opinions_on_invitation_id"
    t.index ["user_id"], name: "index_opinions_on_user_id"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true
    t.index ["target_type", "target_id"], name: "index_settings_on_target_type_and_target_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name"
    t.string "initials", limit: 2
    t.string "email"
    t.string "job_title"
    t.integer "role", default: 4
    t.string "title", limit: 30
    t.boolean "appointeeable", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "accepts", "invitations"
  add_foreign_key "accepts", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "invitations"
  add_foreign_key "comments", "users"
  add_foreign_key "opinions", "invitations"
  add_foreign_key "opinions", "users"
end
