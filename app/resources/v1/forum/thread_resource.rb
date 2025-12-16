# frozen_string_literal: true

class V1::Forum::ThreadResource < V1::ApplicationResource
  self.model = Forum::Thread

  attribute :title, :string
  attribute :closed_at, :datetime do
    writable { self.class.user_can_create_or_update?(context) }
  end
  attribute :amount_of_posts, :integer, writable: false do
    @object.posts.size
  end
  attribute :read, :boolean, writable: false do
    @object.read?(current_user)
  end

  has_one :author, resource: V1::UserResource
  has_one :category, resource: V1::Forum::CategoryResource
  has_many :posts, resource: V1::Forum::PostResource

  filter :category, :integer

  searchable_fields :title

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end
end
