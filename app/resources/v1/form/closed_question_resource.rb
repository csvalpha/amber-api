class V1::Form::ClosedQuestionResource < V1::ApplicationResource
  model_name 'Form::ClosedQuestion'
  attributes :question, :field_type, :required, :position

  has_one :form, always_include_linkage_data: true
  has_many :options, class_name: 'ClosedQuestionOption', always_include_linkage_data: true

  def self.records(options = {})
    options[:includes] = [:options] if options[:context][:action] == 'index'
    super(options)
  end

  def self.creatable_fields(_context)
    %i[question field_type required position form]
  end
end
