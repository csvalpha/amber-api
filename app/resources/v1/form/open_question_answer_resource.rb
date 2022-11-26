class V1::Form::OpenQuestionAnswerResource < V1::ApplicationResource
  model_name 'Form::OpenQuestionAnswer'
  attributes :answer

  has_one :response, always_include_linkage_data: true
  has_one :question, class_name: 'OpenQuestion', always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[answer response question]
  end
end
