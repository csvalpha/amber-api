class UpdateRoomAdvertsAvailableFromStringToDate < ActiveRecord::Migration[7.0]
  def up
    # Clear existing data to avoid type conversion issues
    RoomAdvert.update_all(available_from: nil)
    # Change column type from string to date
    change_column :room_adverts, :available_from, :date
  end

  def down
    change_column :room_adverts, :available_from, :string
  end
end
