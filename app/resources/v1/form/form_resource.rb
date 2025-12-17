# frozen_string_literal: true

class V1::Form::FormResource < V1::ApplicationResource
  self.model = Form::Form

  with_timestamps

  attribute :respond_from, :datetime
  attribute :respond_until, :datetime
  attribute :amount_of_responses, :integer, writable: false do
    @object.responses.completed.size
  end
  attribute :current_user_response_id, :integer, writable: false do
    current_user_response&.id
  end
  attribute :current_user_response_completed, :boolean, writable: false do
    current_user_response&.completed
  end

  has_many :responses, resource: V1::Form::ResponseResource
  has_many :open_questions, resource: V1::Form::OpenQuestionResource
  has_many :closed_questions, resource: V1::Form::ClosedQuestionResource

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end

  def base_scope
    scope = super
    if context&.dig(:action) == 'index'
      scope = scope.includes(:responses, :open_questions, :closed_questions)
    end
    scope
  end

  private

  def current_user_response
    @current_user_response ||= @object.responses.find_by(user_id: current_user&.id)
  end
end
