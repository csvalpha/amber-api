class V1::PhotoCommentResource < V1::ApplicationResource
  attributes :content

  has_one :photo, always_include_linkage_data: true
  has_one :author, class_name: 'User', always_include_linkage_data: true

  before_save do
    @model.author_id = current_user.id if @model.new_record?
  end

  def self.creatable_fields(_context)
    %i[content photo]
  end
end
