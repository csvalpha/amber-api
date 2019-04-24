class V1::ArticleCommentsController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[index show get_related_resources]
end
