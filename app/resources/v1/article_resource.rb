# frozen_string_literal: true

class V1::ArticleResource < V1::ApplicationResource
  self.model = Article

  with_timestamps

  attribute :title, :string
  attribute :content, :string
  attribute :publicly_visible, :boolean
  attribute :content_camofied, :string, writable: false do
    camofy(@object['content'])
  end
  attribute :cover_photo, :string, readable: false # Write-only for uploads
  attribute :amount_of_comments, :integer, writable: false do
    @object.comments.size
  end
  attribute :cover_photo_url, :string, writable: false do
    @object.cover_photo.url
  end
  attribute :author_name, :string, writable: false do
    @object.group ? @object.group.name : @object.author.full_name
  end
  attribute :avatar_thumb_url, :string, writable: false do
    @object.group ? @object.group.avatar.thumb.url : @object.author.avatar.thumb.url
  end
  attribute :pinned, :boolean, writable: -> { self.class.update_permission? }

  has_one :author, resource: V1::UserResource
  has_one :group
  has_many :comments, resource: V1::ArticleCommentResource

  searchable_fields :title, :content

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
