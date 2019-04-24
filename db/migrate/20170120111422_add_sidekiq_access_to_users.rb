class AddSidekiqAccessToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sidekiq_access, :boolean
  end
end
