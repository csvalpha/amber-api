class AddPinnedToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :pinned, :boolean, default: false, null: false
  end
end
