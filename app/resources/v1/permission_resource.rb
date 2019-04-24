class V1::PermissionResource < V1::ApplicationResource
  require 'case_transform'
  attributes :name

  def name
    CaseTransform.dash(@model.name)
  end
end
