class AddGroupToPhotoAlbum < ActiveRecord::Migration[6.1]
  def change
    add_reference :photo_albums, :author, index: true
    add_reference :photo_albums, :group, index: true
  end
end
