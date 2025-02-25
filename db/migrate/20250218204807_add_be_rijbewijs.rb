class AddBeRijbewijs < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :trailer_drivers_license, default: false, null: false
      t.boolean :setup_complete, :boolean, default: false, null: false
    end
  end
end
