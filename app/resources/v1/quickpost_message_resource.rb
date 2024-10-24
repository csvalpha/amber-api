class V1::QuickpostMessageResource < V1::ApplicationResource
  attributes :message

  has_one :author, class_name: 'User', always_include_linkage_data: true

  before_create do
    @model.author_id = current_user.id
  end

  def self.creatable_fields(_context)
    [:message]
  end

  def self.searchable_fields
    %i[message]
  end
end
