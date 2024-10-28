class UpdateRoomAdvertsAvailableFromStringToDate < ActiveRecord::Migration[7.0]
  def up
    # Clear existing data to avoid type conversion issues
    RoomAdvert.update_all(available_from: nil)
    # Change column type from string to date
    change_column :room_adverts, :available_from, :date
    # Populate the column with a default value
    Roomadvert.where(available_from: nil).update_all(available_from: Date.today)
    # Make the column required
    change_column_null :room_adverts, :available_from, false
  end

  def down
    # Allow NULL values again
    change_column_null :room_adverts, :available_from, true
    # Change column type back to string
    change_column :room_adverts, :available_from, :string
  end
end
