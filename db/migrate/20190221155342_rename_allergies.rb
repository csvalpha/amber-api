class RenameAllergies < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :allergies, :food_preferences
  end
end
