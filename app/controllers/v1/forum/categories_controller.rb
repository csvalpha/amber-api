# frozen_string_literal: true

module V1::Forum
  class CategoriesController < V1::ApplicationController
    include GraphitiCrud

    graphiti_resource V1::Forum::CategoryResource
  end
end
