# frozen_string_literal: true

class V1::PermissionsController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::PermissionResource
end
