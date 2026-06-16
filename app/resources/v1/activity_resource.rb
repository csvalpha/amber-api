# frozen_string_literal: true

class V1::ActivityResource < V1::ApplicationResource
  self.model = Activity

  with_timestamps

  attribute :title, :string
  attribute :description, :string
  attribute :description_camofied, :string, writable: false do
    camofy(@object['description'])
  end
  attribute :price, :float
  attribute :location, :string
  attribute :start_time, :datetime
  attribute :end_time, :datetime
  attribute :category, :string
  attribute :publicly_visible, :boolean
  attribute :cover_photo_url, :string, writable: false do
    @object.cover_photo.url
  end
  attribute :cover_photo, :string, readable: false # Write-only for uploads

  has_one :form, resource: V1::Form::FormResource
  has_one :author, resource: V1::UserResource
  has_one :group

  filter :upcoming, :boolean do
    eq do |scope, value|
      value ? scope.upcoming : scope
    end
  end

  filter :closing, :boolean do
    eq do |scope, value|
      value ? scope.closing : scope
    end
  end

  filter :group, :integer do
    eq do |scope, value|
      scope.where(group_id: value)
    end
  end

  sort :form_respond_until, :datetime do |scope, direction|
    scope.joins(:form).order("form_forms.respond_until #{direction}")
  end

  searchable_fields :title, :description, :location

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
