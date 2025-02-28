class RemoveGroupEmail < ActiveRecord::Migration[5.1]
  def change
    remove_column :groups, :email
  end
end
