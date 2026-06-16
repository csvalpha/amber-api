# frozen_string_literal: true

class V1::PhotoTagResource < V1::ApplicationResource
  self.model = PhotoTag

  with_timestamps

  attribute :x, :float
  attribute :y, :float

  has_one :photo
  has_one :author, resource: V1::UserResource
  has_one :tagged_user, resource: V1::UserResource

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end
end
