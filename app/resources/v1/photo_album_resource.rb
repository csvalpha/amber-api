# frozen_string_literal: true

class V1::PhotoAlbumResource < V1::ApplicationResource
  self.model = PhotoAlbum

  with_timestamps

  attribute :title, :string
  attribute :date, :date
  attribute :publicly_visible, :boolean

  filter :without_photo_tags, :boolean do
    eq { |scope, value| value ? scope.without_photo_tags : scope }
  end

  has_many :photos
  has_one :author, resource: V1::UserResource
  has_one :group

  searchable_fields :title

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end

  before_save do |model|
    user_is_member_of_group?(model)
  end

  private

  def user_is_member_of_group?(model)
    return true unless model.group
    return true if current_user.permission?(:update, model)
    return false if current_user.current_group_member?(model.group)

    raise AmberError::NotMemberOfGroupError
  end
end
