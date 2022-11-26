class V1::PhotoAlbumResource < V1::ApplicationResource
  attributes :title, :date, :publicly_visible

  has_many :photos
  has_one :author, class_name: 'User', always_include_linkage_data: true
  has_one :group, always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[title date publicly_visible group]
  end

  def self.searchable_fields
    %i[title]
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
