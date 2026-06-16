# frozen_string_literal: true

module V1::Form
  class OpenQuestionAnswersController < V1::ApplicationController
    include GraphitiCrud

    graphiti_resource V1::Form::OpenQuestionAnswerResource
  end
end
