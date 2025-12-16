# frozen_string_literal: true

class V1::Form::ClosedQuestionResource < V1::ApplicationResource
  self.model = Form::ClosedQuestion

  attribute :question, :string
  attribute :field_type, :string
  attribute :required, :boolean
  attribute :position, :integer

  has_one :form, resource: V1::Form::FormResource
  has_many :options, resource: V1::Form::ClosedQuestionOptionResource

  def base_scope
    scope = super
    if context&.dig(:action) == 'index'
      scope = scope.includes(:options)
    end
    scope
  end
end
