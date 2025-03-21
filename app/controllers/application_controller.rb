class ApplicationController < JSONAPI::ResourceController
  include Pundit::Authorization

  before_action :set_paper_trail_whodunnit
  before_action :set_sentry_context
  protect_from_forgery with: :null_session
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Disable content_type check, since it makes testing practically impossible
  # and does not add any layers of usefulness or security.
  # TODO: Remove when JR docs include instructions on rspec with this header
  def verify_content_type_header
    true
  end

  def pundit_user
    current_user || current_application
  end

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token&.resource_owner_id)
  end

  def current_application
    doorkeeper_token&.application
  end

  private

  def set_sentry_context
    Sentry.set_user(
      id: current_user.try(:id)
    )
    Sentry.set_extras(
      params: params.to_unsafe_h,
      url: request.url
    )
  end

  def user_not_authorized
    head :forbidden
  end
end
