class RemoveSidekiqColom < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :sidekiq_access, :boolean, if_exists: true

    Permission.find_or_create_by!(name: 'sidekiq.read')
  end
end
