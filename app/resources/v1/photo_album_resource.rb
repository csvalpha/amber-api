class V1::PhotoAlbumResource < V1::ApplicationResource
  attributes :title, :date, :publicly_visible

  has_many :photos

  def self.creatable_fields(_context)
    %i[title date publicly_visible]
  end

  def self.searchable_fields
    %i[title]
  end
end
