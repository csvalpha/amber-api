# frozen_string_literal: true

class V1::BookResource < V1::ApplicationResource
  self.model = Book

  attribute :title, :string
  attribute :author, :string
  attribute :description, :string
  attribute :isbn, :string
  attribute :cover_photo, :string, readable: false # Write-only
  attribute :cover_photo_url, :string, writable: false do
    @object.cover_photo.url
  end

  searchable_fields :title, :author, :description, :isbn
end
