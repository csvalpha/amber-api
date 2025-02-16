class RemoveAllowContactSharing < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :allow_contactsync_sharing
    User.find_each do |user|
      user.webdav_secret_key = nil
    end
  end
end
