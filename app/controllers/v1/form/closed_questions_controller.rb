# frozen_string_literal: true

module V1::Form
  class ClosedQuestionsController < V1::ApplicationController
    include GraphitiCrud

    graphiti_resource V1::Form::ClosedQuestionResource
  end
end
