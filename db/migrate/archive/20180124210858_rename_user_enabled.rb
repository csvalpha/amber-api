class RenameUserEnabled < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :enabled, :login_enabled
    add_index :users, :login_enabled
  end
end
