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

ActiveRecord::Schema.define(version: 20170918083218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id"
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "articles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",      limit: 255, null: false
    t.text     "content"
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["slug"], name: "index_articles_on_slug", unique: true, using: :btree
  add_index "articles", ["title"], name: "index_articles_on_title", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "provider",   limit: 255, null: false
    t.string   "uid",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "commit_counts", force: :cascade do |t|
    t.integer "commit_count"
    t.integer "project_id"
    t.integer "user_id"
  end

  add_index "commit_counts", ["project_id"], name: "index_commit_counts_on_project_id", using: :btree
  add_index "commit_counts", ["user_id"], name: "index_commit_counts_on_user_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "user_id"
    t.string   "slug",       limit: 255
  end

  add_index "documents", ["project_id"], name: "index_documents_on_project_id", using: :btree
  add_index "documents", ["slug", "user_id"], name: "index_documents_on_slug_and_user_id", unique: true, using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "event_instances", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "title",              limit: 255
    t.string   "hangout_url",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid",                limit: 255
    t.string   "category",           limit: 255
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "yt_video_id",        limit: 255
    t.text     "participants"
    t.string   "hoa_status",         limit: 255
    t.boolean  "url_set_directly",               default: false
    t.boolean  "youtube_tweet_sent",             default: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",                                      limit: 255
    t.string   "category",                                  limit: 255
    t.text     "description"
    t.string   "repeats",                                   limit: 255
    t.integer  "repeats_every_n_weeks"
    t.integer  "repeats_weekly_each_days_of_the_week_mask"
    t.boolean  "repeat_ends"
    t.date     "repeat_ends_on"
    t.string   "time_zone",                                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url",                                       limit: 255
    t.string   "slug",                                      limit: 255
    t.datetime "start_datetime"
    t.integer  "duration"
    t.text     "exclusions"
    t.integer  "project_id"
    t.integer  "creator_id"
  end

  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree
  add_index "events", ["start_datetime"], name: "index_events_on_start_datetime", using: :btree

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",                               null: false
    t.string   "followable_type", limit: 255,                 null: false
    t.integer  "follower_id",                                 null: false
    t.string   "follower_type",   limit: 255,                 null: false
    t.boolean  "blocked",                     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "hangout_participants_snapshots", force: :cascade do |t|
    t.integer "event_instance_id"
    t.text    "participants"
  end

  create_table "karmas", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "total",                                            default: 0
    t.integer  "hangouts_attended_with_more_than_one_participant", default: 0
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
  end

  create_table "newsletters", force: :cascade do |t|
    t.string   "title",        limit: 255,                 null: false
    t.string   "subject",      limit: 255,                 null: false
    t.text     "body",                                     null: false
    t.boolean  "do_send",                  default: false
    t.boolean  "was_sent",                 default: false
    t.integer  "last_user_id",             default: 0
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_sources", force: :cascade do |t|
    t.string  "type"
    t.string  "identifier"
    t.integer "subscription_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "free_trial_length_days"
    t.string   "third_party_identifier"
    t.integer  "amount"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "category"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "description"
    t.string   "status",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "slug",               limit: 255
    t.string   "github_url",         limit: 255
    t.string   "pivotaltracker_url", limit: 255
    t.text     "pitch"
    t.integer  "commit_count",                   default: 0
    t.string   "image_url",          limit: 255
    t.datetime "last_github_update"
  end

  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "source_repositories", force: :cascade do |t|
    t.string   "url"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "static_pages", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.integer  "parent_id"
    t.string   "slug",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "static_pages", ["slug"], name: "index_static_pages_on_slug", unique: true, using: :btree

  create_table "statuses", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "type"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "user_id"
    t.integer  "plan_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  add_index "taggings", ["tagger_type"], name: "index_taggings_on_tagger_type", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.boolean  "display_email"
    t.string   "slug",                   limit: 255
    t.string   "youtube_id",             limit: 255
    t.boolean  "display_profile",                    default: true
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country_name",           limit: 255
    t.string   "city",                   limit: 255
    t.string   "region",                 limit: 255
    t.string   "youtube_user_name",      limit: 255
    t.string   "github_profile_url",     limit: 255
    t.boolean  "display_hire_me"
    t.text     "bio"
    t.boolean  "receive_mailings",                   default: true
    t.integer  "timezone_offset"
    t.string   "country_code",           limit: 255
    t.integer  "status_count",                       default: 0
    t.datetime "deleted_at"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255, null: false
    t.integer  "item_id",                null: false
    t.string   "event",      limit: 255, null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type", limit: 255
    t.integer  "voter_id"
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag"
    t.string   "vote_scope",   limit: 255
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "events", "users", column: "creator_id"
end
