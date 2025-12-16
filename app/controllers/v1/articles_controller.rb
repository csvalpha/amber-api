# frozen_string_literal: true

class V1::ArticlesController < V1::ApplicationController
  include GraphitiCrud

  before_action :doorkeeper_authorize!, except: %i[index show]

  graphiti_resource V1::ArticleResource
end
