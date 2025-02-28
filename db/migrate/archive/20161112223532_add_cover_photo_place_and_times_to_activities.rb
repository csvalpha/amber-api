class AddCoverPhotoPlaceAndTimesToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :cover_photo, :string
    add_column :activities, :location, :string
    add_column :activities, :start_time, :datetime
    add_column :activities, :end_time, :datetime
  end
end
