class V1::Form::ClosedQuestionOptionResource < V1::ApplicationResource
  model_name 'Form::ClosedQuestionOption'
  attributes :option, :position

  has_one :question, class_name: 'ClosedQuestion', always_include_linkage_data: true
  has_many :answers, class_name: 'ClosedQuestionAnswer', always_include_linkage_data: true

  def self.records(options = {})
    options[:includes] = [:answers] if options[:context][:action] == 'index'
    super(options)
  end

  def self.creatable_fields(_context)
    %i[option position question]
  end
end
