class V1::PhotoTagResource < V1::ApplicationResource
  attributes :x
  attributes :y

  has_one :photo, always_include_linkage_data: true
  has_one :author, always_include_linkage_data: true
  has_one :tagged_user, always_include_linkage_data: true

  before_create do
    @model.author_id = current_user.id
  end

  def self.creatable_fields(_context)
    %i[x y photo tagged_user]
  end
end
