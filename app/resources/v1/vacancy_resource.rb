# frozen_string_literal: true

class V1::VacancyResource < V1::ApplicationResource
  self.model = Vacancy

  attribute :title, :string
  attribute :description, :string
  attribute :description_camofied, :string, writable: false do
    camofy(@object['description'])
  end
  attribute :workload, :string
  attribute :workload_peak, :string
  attribute :contact, :string
  attribute :deadline, :date
  attribute :author_name, :string, writable: false do
    @object.group ? @object.group.name : @object.author.full_name
  end
  attribute :avatar_thumb_url, :string, writable: false do
    @object.group ? @object.group.avatar.thumb.url : @object.author.avatar.thumb.url
  end
  attribute :cover_photo_url, :string, writable: false do
    @object.cover_photo.url
  end
  attribute :cover_photo, :string, readable: false # Write-only

  has_one :group
  has_one :author, resource: V1::UserResource

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
