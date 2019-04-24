class AddCoverPhotosToArticlesAndGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :cover_photo, :string
    add_column :groups, :cover_photo, :string
  end
end
