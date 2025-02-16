class RemoveUserEnums < ActiveRecord::Migration[5.1]
  def up # rubocop:disable Metrics/AbcSize
    change_column :users, :picture_publication_preference, :string, default: 'always_ask'
    change_column :users, :almanak_subscription_preference, :string, default: 'physical'
    change_column :users, :digtus_subscription_preference, :string, default: 'physical'
    change_column :users, :user_details_sharing_preference, :string

    ppp_migration = { '0' => 'always_publish', '1' => 'always_ask', '2' => 'never_publish' }
    asp_migration = { '0' => 'physical', '1' => 'digital', '2' => 'no_subscription' }
    dsp_migration = { '0' => 'physical', '1' => 'digital', '2' => 'no_subscription' }
    uds_migration = { '0' => 'hidden', '1' => 'members_only', '2' => 'all_users' }

    User.find_each do |user|
      user.picture_publication_preference = ppp_migration[user.picture_publication_preference]
      user.almanak_subscription_preference = asp_migration[user.almanak_subscription_preference]
      user.digtus_subscription_preference = dsp_migration[user.digtus_subscription_preference]
      user.user_details_sharing_preference = uds_migration[user.user_details_sharing_preference]
      user.save
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'This migration cannot be rolledback'
  end
end
