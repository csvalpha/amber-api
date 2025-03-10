class V1::Form::FormResource < V1::ApplicationResource
  model_name 'Form::Form'
  attributes :respond_from, :respond_until, :amount_of_responses, :current_user_response_id,
             :current_user_response_completed

  def amount_of_responses
    @model.responses.completed.size
  end

  def current_user_response
    @model.responses.find_by(user_id: current_user.id)
  end

  def current_user_response_id
    current_user_response.try(:id)
  end

  def current_user_response_completed
    current_user_response.try(:completed)
  end

  def self.records(options = {})
    options[:includes] = %i[responses open_questions closed_questions] if options[:context][:action] == 'index'
    super
  end

  def self.creatable_fields(_context)
    %i[group respond_from respond_until]
  end

  before_create do
    @model.author_id = current_user.id
  end

  has_many :responses, always_include_linkage_data: true
  has_many :open_questions, always_include_linkage_data: true
  has_many :closed_questions, always_include_linkage_data: true
end
