# frozen_string_literal: true

class V1::MembershipsController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::MembershipResource
end
