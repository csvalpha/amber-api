class V1::Form::ClosedQuestionAnswerResource < V1::ApplicationResource
  model_name 'Form::ClosedQuestionAnswer'

  has_one :response, always_include_linkage_data: true
  has_one :option, class_name: 'ClosedQuestionOption', always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[option response]
  end
end
