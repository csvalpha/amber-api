class UpdateRoomAdvertsAvailableFromStringToDate < ActiveRecord::Migration[7.0]
  def change
    remove_column :room_adverts, :available_from, :string
    add_column :room_adverts, :available_from, :date
    change_column_null :room_adverts, :available_from, false
  end
end
