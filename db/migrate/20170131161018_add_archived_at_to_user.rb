class AddArchivedAtToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :archived_at, :datetime
    change_column_null :users, :address, true
    change_column_null :users, :postcode, true
    change_column_null :users, :city, true
    change_column_null :users, :vegetarian, true
  end
end
