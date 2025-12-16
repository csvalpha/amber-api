# frozen_string_literal: true

class V1::VacanciesController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::VacancyResource
end
