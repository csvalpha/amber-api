class V1::BookResource < V1:: ApplicationResource
  attributes :title, :author, :description, :isbn, :cover_photo, :cover_photo_url

  def cover_photo_url
    @model.cover_photo.url
  end

  def fetchable_fields
    super - [:cover_photo]
  end

  def self.creatable_fields(_context)
    %i[title author description isbn cover_photo]
  end

  def self.searchable_fields
    %i[title author description isbn]
  end

  def self.sortable_fields(_context)
    super
  end
end
