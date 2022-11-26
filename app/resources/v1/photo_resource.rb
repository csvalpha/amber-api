class V1::PhotoResource < V1::ApplicationResource
  attributes :image_url, :image_thumb_url, :image_medium_url, :amount_of_comments, :exif_make,
             :exif_model, :exif_date_time_original, :exif_exposure_time, :exif_aperture_value,
             :exif_iso_speed_ratings, :exif_copyright, :exif_lens_model, :exif_focal_length

  def image_thumb_url
    @model.image.thumb.url
  end

  def image_medium_url
    @model.image.medium.url
  end

  def amount_of_comments
    @model.comments.size
  end

  filter :with_comments, apply: ->(records, _value, _options) { records.with_comments }

  has_one :photo_album, always_include_linkage_data: true
  has_one :uploader, class_name: 'User', always_include_linkage_data: true
  has_many :comments, class_name: 'PhotoComment'
end
