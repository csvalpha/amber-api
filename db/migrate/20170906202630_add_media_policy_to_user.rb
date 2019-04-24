class AddMediaPolicyToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :picture_publication_preference, :integer, default: 1
  end
end
