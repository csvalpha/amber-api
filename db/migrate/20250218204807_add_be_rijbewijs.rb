class AddBeRijbewijs < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :trailer_drivers_license, :boolean, default: false, null: false
    add_column :users, :setup_complete, :boolean, default: false, null: false
  end
end
