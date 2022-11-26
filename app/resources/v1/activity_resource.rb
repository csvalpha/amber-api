class V1::ActivityResource < V1::ApplicationResource
  attributes :title, :description, :description_camofied, :price, :location, :start_time,
             :end_time, :category, :publicly_visible, :cover_photo_url, :cover_photo

  def cover_photo_url
    @model.cover_photo.url
  end

  def description_camofied
    camofy(@model['description'])
  end

  has_one :form, class_name: 'Form::Form', always_include_linkage_data: true
  has_one :author, class_name: 'User', always_include_linkage_data: true
  has_one :group, always_include_linkage_data: true

  filter :upcoming, apply: ->(records, _value, _options) { records.upcoming }
  filter :closing, apply: ->(records, _value, _options) { records.closing }
  filter :group, apply: ->(records, value, _options) { records.where(group_id: value) }

  def fetchable_fields
    super - [:cover_photo]
  end

  def self.creatable_fields(_context)
    %i[form title description group respond_until respond_from price
       location start_time end_time category publicly_visible cover_photo]
  end

  def self.searchable_fields
    %i[title description location]
  end

  def self.sortable_fields(context)
    super + [:'form.respond_until']
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
