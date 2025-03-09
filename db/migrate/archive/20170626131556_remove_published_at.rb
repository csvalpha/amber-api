class RemovePublishedAt < ActiveRecord::Migration[5.1]
  def change
    remove_column :articles, :published_at
  end
end
