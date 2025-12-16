# frozen_string_literal: true

class V1::ArticleCommentResource < V1::ApplicationResource
  self.model = ArticleComment

  attribute :content, :string

  has_one :article
  has_one :author, resource: V1::UserResource

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end
end
