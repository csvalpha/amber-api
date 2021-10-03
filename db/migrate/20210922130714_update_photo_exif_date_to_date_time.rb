require 'exifr/jpeg'

class UpdatePhotoExifDateToDateTime < ActiveRecord::Migration[6.1]
  def up
    change_column :photos, :exif_date_time_original, :datetime

    Photo.reset_column_information

    # Update date_time_original for each photo to include the time
    Photo.with_deleted.each do |photo|
      next unless photo.jpeg?

      exif_data = EXIFR::JPEG.new(photo.image.file.file)
      photo.exif_date_time_original = exif_data.date_time_original

      # Using touch false to prevent updating the timestamps
      photo.save(touch: false)
    end
  end

  def down
    change_column :photos, :exif_date_time_original, :date
  end
end
