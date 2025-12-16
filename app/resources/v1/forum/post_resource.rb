# frozen_string_literal: true

class V1::Forum::PostResource < V1::ApplicationResource
  self.model = Forum::Post

  attribute :message, :string
  attribute :message_camofied, :string, writable: false do
    camofy(@object['message'])
  end

  has_one :author, resource: V1::UserResource
  has_one :thread, resource: V1::Forum::ThreadResource

  filter :thread, :integer

  searchable_fields :message

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end
end
