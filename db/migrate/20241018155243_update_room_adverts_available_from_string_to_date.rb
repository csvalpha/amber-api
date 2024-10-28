class UpdateRoomAdvertsAvailableFromStringToDate < ActiveRecord::Migration[7.0]
  def change
    remove_column :room_adverts, :available_from, :string
    add_column :room_adverts, :available_from, :date
  end
end
