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
    Graphiti.with_context(context, action_name.to_sym) do
      resources = resource_class.all(params)
      render json: resources.to_jsonapi
    end
  end

  def show
    Graphiti.with_context(context, action_name.to_sym) do
      resource = resource_class.find(params)
      render json: resource.to_jsonapi
    end
  end

  def create
    Graphiti.with_context(context, action_name.to_sym) do
      resource = resource_class.build(params)

      if resource.save
        render json: resource.to_jsonapi, status: :created
      else
        render json: resource.errors.to_jsonapi, status: :unprocessable_entity
      end
    end
  end

  def update
    Graphiti.with_context(context, action_name.to_sym) do
      resource = resource_class.find(params)

      if resource.update_attributes
        render json: resource.to_jsonapi
      else
        render json: resource.errors.to_jsonapi, status: :unprocessable_entity
      end
    end
  end

  def destroy
    Graphiti.with_context(context, action_name.to_sym) do
      resource = resource_class.find(params)

      if resource.destroy
        head :no_content
      else
        render json: resource.errors.to_jsonapi, status: :unprocessable_entity
      end
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
