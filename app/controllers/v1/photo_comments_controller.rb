# frozen_string_literal: true

class V1::PhotoCommentsController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::PhotoCommentResource
end
