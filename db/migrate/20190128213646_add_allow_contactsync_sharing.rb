class AddAllowContactsyncSharing < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :allow_contactsync_sharing, :boolean, default: true
    add_column :users, :webdav_secret_key, :string
    reversible do |dir|
      dir.up { generate_webdav_secret_key }
    end
  end

  def generate_webdav_secret_key
    User.all.map do |user|
      user.__send__(:generate_webdav_secret_key)
      user.save
    end
  end
end
