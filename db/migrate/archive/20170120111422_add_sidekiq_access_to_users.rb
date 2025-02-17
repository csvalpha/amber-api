class AddSidekiqAccessToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sidekiq_access, :boolean, default: false, null: false
  end
end
