class RemoveContactSync < ActiveRecord::Migration[7.0]
  def change
    remove_column(:users, :webdav_secret_key, type: :string)
  end
end
