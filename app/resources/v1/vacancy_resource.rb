class V1::VacancyResource < V1::ApplicationResource
    attributes :title, :description, :description_camofied, :workload, :workload_peak,
               :contact, :deadline, :author_name, :avatar_thumb_url, :cover_photo_url, :cover_photo

  def cover_photo_url
    @model.cover_photo.url
  end

  def description_camofied
    camofy(@model['description'])
  end

  def author_name
    @model.group ? @model.group.name : @model.author.full_name
  end

  def avatar_thumb_url
    @model.group ? @model.group.avatar.thumb.url : @model.author.avatar.thumb.url
  end

  has_one :group, always_include_linkage_data: true
  has_one :author, always_include_linkage_data: true

  def fetchable_fields
    super - [:cover_photo]
  end

  def self.creatable_fields(_context)
    %i[title description group workload workload_peak contact
      deadline cover_photo]
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