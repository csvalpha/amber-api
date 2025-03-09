class AddExifDataToPhoto < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :exif_make, :string
    add_column :photos, :exif_model, :string
    add_column :photos, :exif_date_time_original, :date
    add_column :photos, :exif_exposure_time, :string
    add_column :photos, :exif_aperture_value, :string
    add_column :photos, :exif_iso_speed_ratings, :string
    add_column :photos, :exif_copyright, :string
    add_column :photos, :exif_lens_model, :string
    add_column :photos, :exif_focal_length, :integer
  end
end
