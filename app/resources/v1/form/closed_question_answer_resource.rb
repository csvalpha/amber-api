# frozen_string_literal: true

class V1::Form::ClosedQuestionAnswerResource < V1::ApplicationResource
  self.model = Form::ClosedQuestionAnswer

  has_one :response, resource: V1::Form::ResponseResource
  has_one :option, resource: V1::Form::ClosedQuestionOptionResource
end
