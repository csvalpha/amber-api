class V1::Vote::FormResource < V1::ApplicationResource
  model_name 'Vote::Form'
  attributes :question

  has_one :author, always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[question]
  end

  before_create do
    @model.author_id = current_user.id
  end
end
