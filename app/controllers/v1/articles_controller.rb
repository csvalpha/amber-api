class V1::ArticlesController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[index show]
end
