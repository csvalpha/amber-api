# frozen_string_literal: true

class V1::PhotoCommentResource < V1::ApplicationResource
  self.model = PhotoComment

  attribute :content, :string

  has_one :photo
  has_one :author, resource: V1::UserResource

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end
end
