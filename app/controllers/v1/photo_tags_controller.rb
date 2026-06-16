# frozen_string_literal: true

class V1::PhotoTagsController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::PhotoTagResource
end
