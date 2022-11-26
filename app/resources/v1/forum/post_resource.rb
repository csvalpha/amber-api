class V1::Forum::PostResource < V1::ApplicationResource
  model_name 'Forum::Post'
  attributes :message, :message_camofied

  def message_camofied
    camofy(@model['message'])
  end

  has_one :author, class_name: 'User', always_include_linkage_data: true
  has_one :thread

  filter :thread

  def self.creatable_fields(_context)
    %i[message user thread]
  end

  def self.searchable_fields
    %i[message]
  end

  before_create do
    @model.author_id = current_user.id
  end
end
