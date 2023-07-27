class V1::RoomResource < V1::ApplicationResource
  attributes :house_name, :location, :contact, :description, :description_camofied,
             :publicly_visible, :cover_photo_url, :cover_photo

  def cover_photo_url
    @model.cover_photo.url
  end

  def description_camofied
    camofy(@model['description'])
  end

  has_one :author, always_include_linkage_data: true

  def fetchable_fields
    super - [:cover_photo]
  end

  def self.creatable_fields(_context)
    %i[house_name location contact description cover_photo publicly_visible]
  end

  before_create do
    @model.author_id = current_user.id
  end

end
