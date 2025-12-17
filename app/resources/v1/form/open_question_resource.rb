# frozen_string_literal: true

class V1::Form::OpenQuestionResource < V1::ApplicationResource
  self.model = Form::OpenQuestion

  with_timestamps

  attribute :question, :string
  attribute :field_type, :string
  attribute :required, :boolean
  attribute :position, :integer

  has_one :form, resource: V1::Form::FormResource
  has_many :answers, resource: V1::Form::OpenQuestionAnswerResource

  def base_scope
    scope = super
    if context&.dig(:action) == 'index'
      scope = scope.includes(:answers)
    end
    scope
  end
end
