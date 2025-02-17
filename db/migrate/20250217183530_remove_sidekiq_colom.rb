class RemoveSidekiqColom < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :sidekiq_access
  end
end
