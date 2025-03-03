class V1::ApplicationController < ApplicationController
  before_action :doorkeeper_authorize!
  rescue_from AmberError::NotMemberOfGroupError, with: :user_is_not_member_of_group_error

  def context
    { user: current_user, application: current_application, action: params[:action] }
  end

  def model_class
    self.class.name.underscore.sub('v1/', '').sub(/_controller$/, '')
        .singularize.to_s.camelize.safe_constantize
  end

  def set_model
    @model = model_class.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def base_url
    # When request is incoming via Ember proxy you want to add /api in the base_url
    result = super
    return result if result.include? '3000'

    "#{result}/api"
  end

  def permitted_serializable_attributes
    @permitted_serializable_attributes ||= begin
      permitted_serializable_attributes = resource_klass.new(model_class.new,
                                                             context).fetchable_fields
      attrs = params[:attrs].presence || 'id'
      permitted_serializable_attributes & attrs.split(',').map(&:to_sym)
    end
  end

  def user_is_not_member_of_group_error # rubocop:disable Metrics/MethodLength
    render json: {
      errors: [{
        title: 'User is not a member of group ',
        detail: 'User is not a member of group',
        code: '100',
        source: {
          pointer: '/data/relationships/group'
        },
        status: '422'
      }]
    }, status: :unprocessable_entity
  end
end
