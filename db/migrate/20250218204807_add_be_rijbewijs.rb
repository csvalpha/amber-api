class AddBeRijbewijs < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :be_drivers_license, :boolean, default: false, null: false
  end
end
