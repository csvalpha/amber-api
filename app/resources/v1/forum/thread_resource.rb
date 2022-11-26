class V1::Forum::ThreadResource < V1::ApplicationResource
  model_name 'Forum::Thread'
  attributes :title, :closed_at, :amount_of_posts, :read

  def amount_of_posts
    @model.posts.size
  end

  def read
    @model.read?(current_user)
  end

  has_one :author, class_name: 'User', always_include_linkage_data: true
  has_one :category, always_include_linkage_data: true
  has_many :posts

  filter :category

  def self.creatable_fields(context)
    attributes = %i[title author category]

    attributes += [:closed_at] if user_can_create_or_update?(context)
    attributes
  end

  def self.searchable_fields
    %i[title]
  end

  before_create do
    @model.author_id = current_user.id
  end
end
