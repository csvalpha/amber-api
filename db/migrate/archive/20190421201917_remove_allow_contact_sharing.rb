class RemoveAllowContactSharing < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :allow_contactsync_sharing
    User.all.each do |user|
      user.webdav_secret_key = nil
    end
  end
end
