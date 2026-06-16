# frozen_string_literal: true

class V1::RoomAdvertResource < V1::ApplicationResource
  self.model = RoomAdvert

  with_timestamps

  attribute :house_name, :string
  attribute :contact, :string
  attribute :location, :string
  attribute :available_from, :date
  attribute :description, :string
  attribute :description_camofied, :string, writable: false do
    camofy(@object['description'])
  end
  attribute :author_name, :string, writable: false do
    @object.author.full_name
  end
  attribute :cover_photo_url, :string, writable: false do
    @object.cover_photo.url
  end
  attribute :cover_photo, :string, readable: false # Write-only
  attribute :publicly_visible, :boolean

  has_one :author, resource: V1::UserResource

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end
end
