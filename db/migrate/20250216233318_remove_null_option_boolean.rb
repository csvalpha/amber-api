class RemoveNullOptionBoolean < ActiveRecord::Migration[7.0]
  # rubocop:disable Rails/ReversibleMigration, Rails/BulkChangeTable, Metrics/AbcSize, Layout/LineLength
  def change
    execute 'UPDATE static_pages SET publicly_visible = false WHERE publicly_visible IS NULL'
    execute 'UPDATE users SET sidekiq_access = false WHERE sidekiq_access IS NULL'
    execute 'UPDATE users SET otp_required = false WHERE otp_required IS NULL'
    execute 'UPDATE users SET ifes_data_sharing_preference = false WHERE ifes_data_sharing_preference IS NULL'
    execute 'UPDATE users SET info_in_almanak = false WHERE info_in_almanak IS NULL'
    execute 'UPDATE users SET allow_tomato_sharing = false WHERE allow_tomato_sharing IS NULL'
    execute 'UPDATE mail_aliases SET smtp_enabled = false WHERE smtp_enabled IS NULL'
    execute 'UPDATE articles SET pinned = false WHERE pinned IS NULL'
    execute 'UPDATE room_adverts SET publicly_visible = false WHERE publicly_visible IS NULL'

    change_column_default :static_pages, :publicly_visible, false
    change_column_null :static_pages, :publicly_visible, false

    change_column_default :users, :sidekiq_access, false
    change_column_null :users, :sidekiq_access, false

    change_column_default :users, :otp_required, false
    change_column_null :users, :otp_required, false

    change_column_null :users, :ifes_data_sharing_preference, false
    change_column_null :users, :info_in_almanak, false

    change_column_default :users, :allow_tomato_sharing, false
    change_column_null :users, :allow_tomato_sharing, false

    change_column_null :mail_aliases, :smtp_enabled, false
    change_column_null :articles, :pinned, false

    change_column_default :room_adverts, :publicly_visible, false
    change_column_null :room_adverts, :publicly_visible, false
  end
  # rubocop:enable Rails/ReversibleMigration, Rails/BulkChangeTable, Metrics/AbcSize, Layout/LineLength
end
