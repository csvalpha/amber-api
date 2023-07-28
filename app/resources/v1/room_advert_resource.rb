class V1::RoomAdvertResource < V1::ApplicationResource
  attributes :house_name, :contact, :location, :available_from, :description, :description_camofied, 
             :author_name, :cover_photo_url, :cover_photo, :publicly_visible

  def cover_photo_url
    @model.cover_photo.url
  end

  def description_camofied
    camofy(@model['description'])
  end

  def author_name
   @model.author.full_name
  end

  has_one :author, always_include_linkage_data: true

  def fetchable_fields
    super - [:cover_photo]
  end

  def self.creatable_fields(_context)
    %i[house_name contact location available_from description cover_photo publicly_visible]
  end

  before_create do
    @model.author_id = current_user.id
  end

end
