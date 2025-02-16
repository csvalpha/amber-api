class AddTomatoPreference < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :allow_tomato_sharing, :boolean, default: false, null: false
  end
end
