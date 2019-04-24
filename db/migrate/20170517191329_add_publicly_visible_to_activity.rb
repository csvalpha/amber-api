class AddPubliclyVisibleToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :publicly_visible, :boolean, null: false, default: false
  end
end
