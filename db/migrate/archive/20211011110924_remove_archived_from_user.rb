class RemoveArchivedFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :archived_at
  end
end
