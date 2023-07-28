class V1::RoomAdvertsController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[index show]
end
