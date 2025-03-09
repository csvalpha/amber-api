class AddVegetarianToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :vegetarian, :boolean, default: false, null: false
    change_column_null :groups, :kind, false
  end
end
