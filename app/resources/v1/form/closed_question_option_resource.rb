# frozen_string_literal: true

class V1::Form::ClosedQuestionOptionResource < V1::ApplicationResource
  self.model = Form::ClosedQuestionOption

  with_timestamps

  attribute :option, :string
  attribute :position, :integer

  has_one :question, resource: V1::Form::ClosedQuestionResource
  has_many :answers, resource: V1::Form::ClosedQuestionAnswerResource

  def base_scope
    scope = super
    if Graphiti.context[:action] == 'index'
      scope = scope.includes(:answers)
    end
    scope
  end
end
