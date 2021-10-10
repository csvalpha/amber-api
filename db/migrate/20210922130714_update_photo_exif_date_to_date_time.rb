require 'exifr/jpeg'

class UpdatePhotoExifDateToDateTime < ActiveRecord::Migration[6.1]
  def up
    change_column :photos, :exif_date_time_original, :datetime

    Photo.reset_column_information

    # Re-save each photo to update the date_time_original to include the time
    Photo.with_deleted.each do |photo|
      # Using touch false to prevent updating the timestamps
      photo.save(touch: false)
    end
  end

  def down
    change_column :photos, :exif_date_time_original, :date
  end
end
