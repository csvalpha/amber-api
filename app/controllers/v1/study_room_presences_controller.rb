# frozen_string_literal: true

class V1::StudyRoomPresencesController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::StudyRoomPresenceResource
end
