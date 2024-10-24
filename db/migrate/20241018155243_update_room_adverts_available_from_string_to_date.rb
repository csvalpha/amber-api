class UpdateRoomAdvertsAvailableFromStringToDate < ActiveRecord::Migration[7.0]
  def up
    change_column :room_adverts, :available_from, :date
  end

  def down
    change_column :room_adverts, :available_from, :string
  end
end
