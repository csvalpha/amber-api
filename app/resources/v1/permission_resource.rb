# frozen_string_literal: true

require 'case_transform'

class V1::PermissionResource < V1::ApplicationResource
  self.model = Permission

  attribute :name, :string, writable: false do
    CaseTransform.dash(@object.name)
  end
end
