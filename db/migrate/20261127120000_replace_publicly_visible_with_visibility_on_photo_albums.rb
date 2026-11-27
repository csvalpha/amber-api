class ReplacePubliclyVisibleWithVisibilityOnPhotoAlbums < ActiveRecord::Migration[7.2]
  def up
    add_column :photo_albums, :visibility, :string, null: false, default: 'members'
    execute "UPDATE photo_albums SET visibility = 'public' WHERE publicly_visible"
    remove_column :photo_albums, :publicly_visible
  end

  def down
    add_column :photo_albums, :publicly_visible, :boolean, null: false, default: false
    execute "UPDATE photo_albums SET publicly_visible = TRUE WHERE visibility = 'public'"
    remove_column :photo_albums, :visibility
  end
end
