# frozen_string_literal: true

class V1::Form::ResponseResource < V1::ApplicationResource
  self.model = Form::Response

  with_timestamps

  attribute :completed, :boolean

  has_one :user, resource: V1::UserResource
  has_one :form, resource: V1::Form::FormResource
  has_many :open_question_answers, resource: V1::Form::OpenQuestionAnswerResource
  has_many :closed_question_answers, resource: V1::Form::ClosedQuestionAnswerResource

  def base_scope
    scope = super
    if context&.dig(:action) == 'index'
      scope = scope.includes(:open_question_answers, :closed_question_answers)
    end
    scope
  end

  before_save only: [:create] do |model|
    model.user_id = current_user.id
  end
end
