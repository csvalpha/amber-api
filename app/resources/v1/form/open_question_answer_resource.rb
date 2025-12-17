# frozen_string_literal: true

class V1::Form::OpenQuestionAnswerResource < V1::ApplicationResource
  self.model = Form::OpenQuestionAnswer

  with_timestamps

  attribute :answer, :string

  has_one :response, resource: V1::Form::ResponseResource
  has_one :question, resource: V1::Form::OpenQuestionResource
end
