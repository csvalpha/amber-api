class V1::Vote::ResponseResource < V1::ApplicationResource
  model_name 'Vote::Response'
  attributes :response

  has_one :form, always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[form response]
  end

  before_create do
    #binding.pry
    #@model.author_id = current_user.id
  end
end
