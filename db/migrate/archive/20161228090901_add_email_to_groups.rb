class AddEmailToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :email, :string
  end
end
