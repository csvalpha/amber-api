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

ActiveRecord::Schema.define(version: 2022_10_12_154634) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "form_id"
    t.datetime "deleted_at"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover_photo"
    t.string "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "title"
    t.string "description"
    t.integer "author_id"
    t.integer "group_id"
    t.string "category", null: false
    t.boolean "publicly_visible", default: false, null: false
    t.index ["deleted_at"], name: "index_activities_on_deleted_at"
    t.index ["form_id"], name: "index_activities_on_form_id", unique: true
  end

  create_table "article_comments", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "article_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["article_id"], name: "index_article_comments_on_article_id"
    t.index ["author_id"], name: "index_article_comments_on_author_id"
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.datetime "deleted_at"
    t.boolean "publicly_visible", default: false, null: false
    t.integer "author_id"
    t.string "cover_photo"
    t.integer "comments_count", default: 0, null: false
    t.boolean "pinned", default: false
    t.index ["author_id"], name: "index_articles_on_author_id"
    t.index ["deleted_at"], name: "index_articles_on_deleted_at"
    t.index ["group_id"], name: "index_articles_on_group_id"
  end

  create_table "board_room_presences", id: :serial, force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.text "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_board_room_presences_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.string "author"
    t.string "description"
    t.string "isbn"
    t.string "cover_photo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
  end

  create_table "debit_collections", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.date "date", null: false
    t.integer "author_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_debit_collections_on_author_id"
  end

  create_table "debit_mandates", force: :cascade do |t|
    t.string "iban", null: false
    t.string "iban_holder", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.bigint "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_debit_mandates_on_user_id"
  end

  create_table "debit_transactions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "collection_id"
    t.string "description"
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_debit_transactions_on_collection_id"
    t.index ["user_id"], name: "index_debit_transactions_on_user_id"
  end

  create_table "form_closed_question_answers", id: :serial, force: :cascade do |t|
    t.integer "option_id"
    t.integer "response_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "question_id"
    t.boolean "radio_question", default: false, null: false
    t.index ["question_id", "response_id"], name: "index_form_closed_question_answers_on_question_and_response", unique: true, where: "(radio_question IS TRUE)"
    t.index ["response_id", "option_id"], name: "index_form_closed_question_answers_on_response_id_and_option_id", unique: true
  end

  create_table "form_closed_question_options", id: :serial, force: :cascade do |t|
    t.string "option"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "position", default: 0
  end

  create_table "form_closed_questions", id: :serial, force: :cascade do |t|
    t.string "question"
    t.string "field_type"
    t.integer "position"
    t.boolean "required", default: false, null: false
    t.integer "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "form_forms", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.datetime "respond_until"
    t.datetime "respond_from"
    t.integer "group_id"
    t.integer "responses_count", default: 0, null: false
    t.index ["group_id"], name: "index_form_forms_on_group_id"
  end

  create_table "form_open_question_answers", id: :serial, force: :cascade do |t|
    t.text "answer"
    t.integer "response_id"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["response_id", "question_id"], name: "index_form_open_question_answers_on_response_id_and_question_id", unique: true
  end

  create_table "form_open_questions", id: :serial, force: :cascade do |t|
    t.string "question"
    t.string "field_type"
    t.integer "position"
    t.boolean "required", default: false, null: false
    t.integer "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "form_responses", id: :serial, force: :cascade do |t|
    t.integer "form_id"
    t.integer "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed", default: false, null: false
    t.integer "lock_version"
    t.index ["form_id", "user_id"], name: "index_form_responses_on_form_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_form_responses_on_user_id"
  end

  create_table "forum_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "threads_count", default: 0, null: false
    t.index ["deleted_at"], name: "index_forum_categories_on_deleted_at"
  end

  create_table "forum_posts", id: :serial, force: :cascade do |t|
    t.string "message"
    t.integer "author_id"
    t.integer "thread_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["author_id"], name: "index_forum_posts_on_author_id"
    t.index ["deleted_at"], name: "index_forum_posts_on_deleted_at"
    t.index ["thread_id"], name: "index_forum_posts_on_thread_id"
  end

  create_table "forum_read_threads", force: :cascade do |t|
    t.integer "user_id"
    t.integer "thread_id"
    t.integer "post_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["thread_id"], name: "index_forum_read_threads_on_thread_id"
    t.index ["user_id"], name: "index_forum_read_threads_on_user_id"
  end

  create_table "forum_threads", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "author_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.datetime "closed_at"
    t.integer "posts_count", default: 0, null: false
    t.index ["author_id"], name: "index_forum_threads_on_author_id"
    t.index ["category_id"], name: "index_forum_threads_on_category_id"
    t.index ["deleted_at"], name: "index_forum_threads_on_deleted_at"
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

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "kind", null: false
    t.string "recognized_at_gma"
    t.string "rejected_at_gma"
    t.string "avatar"
    t.boolean "administrative", default: false, null: false
    t.index ["deleted_at"], name: "index_groups_on_deleted_at"
  end

  create_table "groups_permissions", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_groups_permissions_on_deleted_at"
    t.index ["group_id"], name: "index_groups_permissions_on_group_id"
    t.index ["permission_id"], name: "index_groups_permissions_on_permission_id"
  end

  create_table "mail_aliases", force: :cascade do |t|
    t.string "email"
    t.string "moderation_type"
    t.string "description"
    t.integer "group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "moderator_group_id"
    t.boolean "smtp_enabled", default: false
    t.datetime "last_received_at"
    t.index ["email"], name: "index_mail_aliases_on_email", unique: true
    t.index ["moderator_group_id"], name: "index_mail_aliases_on_moderator_group_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.date "start_date", null: false
    t.date "end_date"
    t.string "function"
    t.index ["deleted_at"], name: "index_memberships_on_deleted_at"
    t.index ["group_id", "user_id", "start_date"], name: "index_memberships_on_group_id_and_user_id_and_start_date", unique: true
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "confidential", default: true, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "permissions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_permissions_on_deleted_at"
    t.index ["name"], name: "index_permissions_on_name", unique: true
  end

  create_table "permissions_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_permissions_users_on_deleted_at"
    t.index ["permission_id"], name: "index_permissions_users_on_permission_id"
    t.index ["user_id"], name: "index_permissions_users_on_user_id"
  end

  create_table "photo_albums", id: :serial, force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "publicly_visible", default: false, null: false
    t.bigint "author_id"
    t.bigint "group_id"
    t.index ["author_id"], name: "index_photo_albums_on_author_id"
    t.index ["deleted_at"], name: "index_photo_albums_on_deleted_at"
    t.index ["group_id"], name: "index_photo_albums_on_group_id"
  end

  create_table "photo_comments", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.integer "photo_id"
    t.index ["author_id"], name: "index_photo_comments_on_author_id"
    t.index ["photo_id"], name: "index_photo_comments_on_photo_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.string "image"
    t.integer "photo_album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "original_filename"
    t.integer "uploader_id"
    t.integer "comments_count", default: 0, null: false
    t.string "exif_make"
    t.string "exif_model"
    t.datetime "exif_date_time_original"
    t.string "exif_exposure_time"
    t.string "exif_aperture_value"
    t.string "exif_iso_speed_ratings"
    t.string "exif_copyright"
    t.string "exif_lens_model"
    t.integer "exif_focal_length"
    t.index ["deleted_at"], name: "index_photos_on_deleted_at"
    t.index ["photo_album_id"], name: "index_photos_on_photo_album_id"
    t.index ["uploader_id"], name: "index_photos_on_uploader_id"
  end

  create_table "polls", id: :serial, force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.integer "form_id"
    t.index ["author_id"], name: "index_polls_on_author_id"
    t.index ["form_id"], name: "index_polls_on_form_id"
  end

  create_table "quickpost_messages", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.datetime "datetime"
    t.index ["datetime"], name: "index_quickpost_messages_on_datetime"
    t.index ["deleted_at"], name: "index_quickpost_messages_on_deleted_at"
  end

  create_table "static_pages", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.string "content", null: false
    t.boolean "publicly_visible"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: "vereniging"
    t.index ["slug"], name: "index_static_pages_on_slug", unique: true
  end

  create_table "stored_mails", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "mail_alias_id"
    t.datetime "received_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inbound_email_id"
    t.index ["inbound_email_id"], name: "index_stored_mails_on_inbound_email_id"
    t.index ["mail_alias_id"], name: "index_stored_mails_on_mail_alias_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "first_name", null: false
    t.string "last_name_prefix"
    t.string "last_name", null: false
    t.date "birthday"
    t.string "address"
    t.string "postcode"
    t.string "city"
    t.string "phone_number"
    t.string "food_preferences"
    t.string "study"
    t.date "start_study"
    t.boolean "login_enabled", default: false, null: false
    t.datetime "activated_at"
    t.string "activation_token"
    t.string "avatar"
    t.datetime "activation_token_valid_till"
    t.boolean "sidekiq_access"
    t.boolean "vegetarian", default: false
    t.string "otp_secret_key"
    t.boolean "otp_required"
    t.string "ical_secret_key"
    t.string "picture_publication_preference", default: "always_ask"
    t.string "emergency_contact"
    t.string "emergency_number"
    t.boolean "ifes_data_sharing_preference", default: false
    t.boolean "info_in_almanak", default: false
    t.string "almanak_subscription_preference", default: "physical"
    t.string "digtus_subscription_preference", default: "physical"
    t.string "user_details_sharing_preference"
    t.boolean "allow_tomato_sharing"
    t.string "webdav_secret_key"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login_enabled"], name: "index_users_on_login_enabled"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.datetime "created_at"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "article_comments", "articles"
  add_foreign_key "article_comments", "users", column: "author_id"
  add_foreign_key "articles", "groups"
  add_foreign_key "board_room_presences", "users"
  add_foreign_key "form_responses", "users"
  add_foreign_key "forum_posts", "users", column: "author_id"
  add_foreign_key "forum_threads", "users", column: "author_id"
  add_foreign_key "groups_permissions", "groups"
  add_foreign_key "groups_permissions", "permissions"
  add_foreign_key "mail_aliases", "groups", column: "moderator_group_id"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "permissions_users", "permissions"
  add_foreign_key "permissions_users", "users"
  add_foreign_key "photos", "photo_albums"
  add_foreign_key "photos", "users", column: "uploader_id"
  add_foreign_key "stored_mails", "action_mailbox_inbound_emails", column: "inbound_email_id", on_delete: :cascade
end
