# frozen_string_literal: true

class V1::PollsController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::PollResource
end
