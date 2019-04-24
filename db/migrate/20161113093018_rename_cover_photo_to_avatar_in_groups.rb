class RenameCoverPhotoToAvatarInGroups < ActiveRecord::Migration[5.0]
  def change
    rename_column :groups, :cover_photo, :avatar
  end
end
