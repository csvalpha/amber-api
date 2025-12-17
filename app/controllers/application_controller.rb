# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :set_paper_trail_whodunnit
  before_action :set_sentry_context
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_user || current_application
  end

  # rubocop:disable Rails/FindByOrAssignmentMemoization
  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token&.resource_owner_id)
  end
  # rubocop:enable Rails/FindByOrAssignmentMemoization

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
