# frozen_string_literal: true

class V1::PhotoResource < V1::ApplicationResource
  self.model = Photo

  with_timestamps

  attribute :image_url, :string, writable: false
  attribute :image_thumb_url, :string, writable: false do
    @object.image.thumb.url
  end
  attribute :image_medium_url, :string, writable: false do
    @object.image.medium.url
  end
  attribute :amount_of_comments, :integer, writable: false do
    @object.comments.size
  end
  attribute :amount_of_tags, :integer, writable: false do
    @object.tags.size
  end
  attribute :exif_make, :string, writable: false
  attribute :exif_model, :string, writable: false
  attribute :exif_date_time_original, :datetime, writable: false
  attribute :exif_exposure_time, :string, writable: false
  attribute :exif_aperture_value, :string, writable: false
  attribute :exif_iso_speed_ratings, :integer, writable: false
  attribute :exif_copyright, :string, writable: false
  attribute :exif_lens_model, :string, writable: false
  attribute :exif_focal_length, :string, writable: false

  filter :with_comments, :boolean do
    eq { |scope, value| value ? scope.with_comments : scope }
  end

  filter :with_tags, :boolean do
    eq { |scope, value| value ? scope.with_tags : scope }
  end

  has_one :photo_album
  has_one :uploader, resource: V1::UserResource
  has_many :comments, resource: V1::PhotoCommentResource
  has_many :tags, resource: V1::PhotoTagResource
end
