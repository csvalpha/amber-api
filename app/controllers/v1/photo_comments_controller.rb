class V1::PhotoCommentsController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[index show]
end
