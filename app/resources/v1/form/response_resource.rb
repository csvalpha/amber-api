class V1::Form::ResponseResource < V1::ApplicationResource
  model_name 'Form::Response'
  attributes :completed

  has_one :user, always_include_linkage_data: true
  has_one :form, always_include_linkage_data: true
  has_many :open_question_answers, always_include_linkage_data: true
  has_many :closed_question_answers, always_include_linkage_data: true

  def self.records(options = {})
    if options[:context][:action] == 'index'
      options[:includes] = %i[open_question_answers closed_question_answers]
    end
    super
  end

  def self.creatable_fields(_context)
    %i[form]
  end

  before_create do
    @model.user_id = current_user.id
  end
end
