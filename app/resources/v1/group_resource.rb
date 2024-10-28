class V1::GroupResource < V1::ApplicationResource
  attributes :name, :avatar_url, :avatar_thumb_url, :description, :description_camofied,
             :kind, :recognized_at_gma, :rejected_at_gma, :administrative, :avatar

  def avatar_url
    @model.avatar.url
  end

  def avatar_thumb_url
    @model.avatar.thumb.url
  end

  def description_camofied
    camofy(@model['description'])
  end

  has_many :users
  has_many :memberships
  has_many :mail_aliases
  has_many :permissions

  filter :active, apply: ->(records, _value, _options) { records.active }
  filter :kind
  filter :administrative

  def fetchable_fields
    return super - [:avatar] if current_user

    super - %i[description description_camofied kind
               recognized_at_gma rejected_at_gma administrative avatar]
  end

  def self.creatable_fields(context)
    attributes = %i[avatar description]

    if user_can_create_or_update?(context)
      attributes += %i[name kind recognized_at_gma rejected_at_gma administrative permissions]
    end
    attributes
  end

  def self.searchable_fields
    %i[name]
  end
end
