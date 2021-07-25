# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_21_093118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "title", null: false
    t.text "content"
    t.string "slug", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
    t.index ["title"], name: "index_articles_on_title"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "authentications", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "commit_counts", id: :serial, force: :cascade do |t|
    t.integer "commit_count"
    t.integer "project_id"
    t.integer "user_id"
    t.index ["project_id"], name: "index_commit_counts_on_project_id"
    t.index ["user_id"], name: "index_commit_counts_on_user_id"
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "parent_id"
    t.integer "user_id"
    t.string "slug"
    t.index ["project_id"], name: "index_documents_on_project_id"
    t.index ["slug", "user_id"], name: "index_documents_on_slug_and_user_id", unique: true
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "event_instances", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.string "title"
    t.string "hangout_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "uid"
    t.string "category"
    t.integer "project_id"
    t.integer "user_id"
    t.string "yt_video_id"
    t.text "participants"
    t.string "hoa_status"
    t.boolean "url_set_directly", default: false
    t.boolean "youtube_tweet_sent", default: false
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.text "description"
    t.string "repeats"
    t.integer "repeats_every_n_weeks"
    t.integer "repeats_weekly_each_days_of_the_week_mask"
    t.boolean "repeat_ends"
    t.date "repeat_ends_on"
    t.string "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "url"
    t.string "slug"
    t.datetime "start_datetime"
    t.integer "duration"
    t.text "exclusions"
    t.integer "project_id"
    t.integer "creator_id"
    t.string "for"
    t.integer "modifier_id"
    t.boolean "creator_attendance", default: true
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.index ["start_datetime"], name: "index_events_on_start_datetime"
  end

  create_table "events_slack_channels", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "slack_channel_id", null: false
    t.index ["event_id", "slack_channel_id"], name: "slack_event_channel", unique: true
    t.index ["slack_channel_id", "event_id"], name: "slack_channel_name_event", unique: true
  end

  create_table "follows", id: :serial, force: :cascade do |t|
    t.string "followable_type", null: false
    t.integer "followable_id", null: false
    t.string "follower_type", null: false
    t.integer "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "hangout_participants_snapshots", id: :serial, force: :cascade do |t|
    t.integer "event_instance_id"
    t.text "participants"
  end

  create_table "issue_trackers", force: :cascade do |t|
    t.string "url"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_issue_trackers_on_project_id"
  end

  create_table "karmas", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "total", default: 0
    t.integer "hangouts_attended_with_more_than_one_participant", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "membership_length", default: 0
    t.integer "profile_completeness", default: 0
    t.integer "number_github_contributions", default: 0
    t.integer "activity", default: 0
    t.integer "event_participation", default: 0
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages_projects", id: false, force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "language_id"
    t.index ["language_id"], name: "index_languages_projects_on_language_id"
    t.index ["project_id", "language_id"], name: "index_languages_projects_on_project_id_and_language_id", unique: true
    t.index ["project_id"], name: "index_languages_projects_on_project_id"
  end

  create_table "payment_sources", id: :serial, force: :cascade do |t|
    t.string "type"
    t.string "identifier"
    t.integer "subscription_id"
  end

  create_table "plans", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "free_trial_length_days"
    t.string "third_party_identifier"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "paypal_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "slug"
    t.string "github_url"
    t.string "pivotaltracker_url"
    t.text "pitch"
    t.integer "commit_count", default: 0
    t.string "image_url"
    t.datetime "last_github_update"
    t.string "slack_channel_name"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "projects_slack_channels", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "slack_channel_id", null: false
    t.index ["project_id", "slack_channel_id"], name: "slack_project_channel", unique: true
    t.index ["slack_channel_id", "project_id"], name: "slack_channel_name", unique: true
  end

  create_table "slack_channels", force: :cascade do |t|
    t.string "environment"
    t.string "code"
  end

  create_table "source_repositories", id: :serial, force: :cascade do |t|
    t.string "url"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "static_pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "parent_id"
    t.string "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["slug"], name: "index_static_pages_on_slug", unique: true
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.string "status"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.string "type"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "user_id"
    t.integer "plan_id"
    t.integer "sponsor_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type"], name: "index_taggings_on_tagger_type"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name"
    t.string "last_name"
    t.boolean "display_email"
    t.string "youtube_id"
    t.string "slug"
    t.boolean "display_profile", default: true
    t.float "latitude"
    t.float "longitude"
    t.string "country_name"
    t.string "city"
    t.string "region"
    t.string "youtube_user_name"
    t.string "github_profile_url"
    t.boolean "display_hire_me"
    t.text "bio"
    t.boolean "receive_mailings", default: false
    t.string "country_code"
    t.integer "timezone_offset"
    t.integer "status_count", default: 0
    t.datetime "deleted_at"
    t.integer "event_participation_count", default: 0
    t.boolean "can_see_dashboard", default: false
    t.boolean "admin"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "vanity_conversions", force: :cascade do |t|
    t.integer "vanity_experiment_id"
    t.integer "alternative"
    t.integer "conversions"
    t.index ["vanity_experiment_id", "alternative"], name: "by_experiment_id_and_alternative", unique: true
  end

  create_table "vanity_experiments", force: :cascade do |t|
    t.string "experiment_id"
    t.integer "outcome"
    t.boolean "enabled"
    t.datetime "created_at"
    t.datetime "completed_at"
    t.index ["experiment_id"], name: "index_vanity_experiments_on_experiment_id", unique: true
  end

  create_table "vanity_metric_values", force: :cascade do |t|
    t.integer "vanity_metric_id"
    t.integer "index"
    t.integer "value"
    t.string "date"
    t.index ["vanity_metric_id", "date"], name: "index_vanity_metric_values_on_vanity_metric_id_and_date"
  end

  create_table "vanity_metrics", force: :cascade do |t|
    t.string "metric_id"
    t.datetime "updated_at"
    t.index ["metric_id"], name: "index_vanity_metrics_on_metric_id"
  end

  create_table "vanity_participants", force: :cascade do |t|
    t.string "experiment_id"
    t.string "identity"
    t.integer "shown"
    t.integer "seen"
    t.integer "converted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["experiment_id", "converted"], name: "by_experiment_id_and_converted"
    t.index ["experiment_id", "identity"], name: "by_experiment_id_and_identity", unique: true
    t.index ["experiment_id", "seen"], name: "by_experiment_id_and_seen"
    t.index ["experiment_id", "shown"], name: "by_experiment_id_and_shown"
    t.index ["experiment_id"], name: "index_vanity_participants_on_experiment_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

  add_foreign_key "events", "users", column: "creator_id"
end
