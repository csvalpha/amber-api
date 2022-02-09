class V1::BookResource < V1:: ApplicationResource
  attributes :title, :author, :description, :isbn, :cover_photo

  def fetchable_fields
    super - [:cover_photo]
  end

  def self.creatable_fields(_context)
    %i[title author description isbn cover_photo]
  end

  def self.searchable_fields
    %i[title author description]
  end

  def self.sortable_fields(_context)
    super
  end
end
