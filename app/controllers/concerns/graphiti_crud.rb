# frozen_string_literal: true

# Provides standard Graphiti CRUD actions for controllers
# Include this module to get index, show, create, update, destroy actions
module GraphitiCrud
  extend ActiveSupport::Concern

  included do
    class_attribute :resource_class
  end

  class_methods do
    def graphiti_resource(klass)
      self.resource_class = klass
    end
  end

  def index
    resources = resource_class.all(params, context)
    render jsonapi: resources
  end

  def show
    resource = resource_class.find(params, context)
    render jsonapi: resource
  end

  def create
    resource = resource_class.build(params, context)

    if resource.save
      render jsonapi: resource, status: :created
    else
      render jsonapi_errors: resource
    end
  end

  def update
    resource = resource_class.find(params, context)

    if resource.update_attributes
      render jsonapi: resource
    else
      render jsonapi_errors: resource
    end
  end

  def destroy
    resource = resource_class.find(params, context)

    if resource.destroy
      head :no_content
    else
      render jsonapi_errors: resource
    end
  end

  private

  def resource_class
    self.class.resource_class || infer_resource_class
  end

  def infer_resource_class
    # Infer from controller name: V1::UsersController -> V1::UserResource
    controller_name = self.class.name
    resource_name = controller_name
                    .sub(/Controller$/, '')
                    .singularize + 'Resource'
    resource_name.constantize
  end
end
