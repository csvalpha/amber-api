class V1::MembershipResource < V1::ApplicationResource
  attributes :start_date, :end_date, :function

  has_one :user, always_include_linkage_data: true
  has_one :group, always_include_linkage_data: true

  before_save do
    @model.start_date ||= Date.current
  end

  def self.creatable_fields(_context)
    %i[start_date end_date function group user]
  end
end
