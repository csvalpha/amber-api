class AddPubliclyVisibleToPhotoAlbum < ActiveRecord::Migration[5.0]
  def change
    add_column :photo_albums, :publicly_visible, :boolean, null: false, default: false
  end
end
