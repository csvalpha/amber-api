class UpdatePhotoExifDateToDateTime < ActiveRecord::Migration[6.1]
  def change
    change_column :photos, :exif_date_time_original, :datetime
  end
end
