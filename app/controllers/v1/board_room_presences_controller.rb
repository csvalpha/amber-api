# frozen_string_literal: true

class V1::BoardRoomPresencesController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::BoardRoomPresenceResource
end
