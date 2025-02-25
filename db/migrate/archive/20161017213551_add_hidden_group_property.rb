class AddHiddenGroupProperty < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :hidden, :boolean, null: false, default: false
  end
end
