class AddIndexToPermissions < ActiveRecord::Migration[5.0]
  def change
    add_index :permissions, :name, unique: true
  end
end
