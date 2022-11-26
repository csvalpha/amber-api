class V1::ArticleCommentResource < V1::ApplicationResource
  attributes :content

  has_one :article
  has_one :author, class_name: 'User', always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[content article]
  end

  before_create do
    @model.author_id = current_user.id
  end
end
