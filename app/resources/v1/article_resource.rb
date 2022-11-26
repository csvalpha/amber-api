class V1::ArticleResource < V1::ApplicationResource
  attributes :title, :content, :publicly_visible, :content_camofied, :cover_photo,
             :amount_of_comments, :cover_photo_url, :author_name, :avatar_thumb_url, :pinned

  def amount_of_comments
    @model.comments.size
  end

  def cover_photo_url
    @model.cover_photo.url
  end

  def author_name
    @model.group ? @model.group.name : @model.author.full_name
  end

  def avatar_thumb_url
    @model.group ? @model.group.avatar.thumb.url : @model.author.avatar.thumb.url
  end

  def content_camofied
    camofy(@model['content'])
  end

  has_one :author, class_name: 'User', always_include_linkage_data: true
  has_one :group, always_include_linkage_data: true
  has_many :comments, class_name: 'ArticleComment'

  def fetchable_fields
    super - [:cover_photo]
  end

  def self.creatable_fields(context)
    attributes = %i[title content publicly_visible group cover_photo]

    attributes += [:pinned] if update_permission?(context)
    attributes
  end

  def self.update_permission?(context)
    context[:user]&.permission?(:update, _model_class)
  end

  def self.searchable_fields
    %i[title content]
  end

  before_create do
    @model.author_id = current_user.id
  end

  before_save do
    user_is_member_of_group?
  end

  def user_is_member_of_group?
    return true unless @model.group
    return true if current_user.permission?(:update, @model)
    return if current_user.current_group_member?(@model.group)

    raise AmberError::NotMemberOfGroupError
  end
end
