class V1::Form::OpenQuestionResource < V1::ApplicationResource
  model_name 'Form::OpenQuestion'
  attributes :question, :field_type, :required, :position

  has_one :form, always_include_linkage_data: true
  has_many :answers, class_name: 'OpenQuestionAnswer', always_include_linkage_data: true

  def self.records(options = {})
    options[:includes] = [:answers] if options[:context][:action] == 'index'
    super(options)
  end

  def self.creatable_fields(_context)
    %i[form question field_type required position]
  end
end
