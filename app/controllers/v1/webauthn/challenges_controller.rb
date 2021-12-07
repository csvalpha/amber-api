class V1::Webauthn::ChallengesController < V1::ApplicationController
  before_action :doorkeeper_authorize!
  after_action :verify_authorized

  def create
    authorize Webauthn::Challenge

    create_options = WebAuthn::Credential.options_for_create(
      user: {
        id: current_user.webauthn_id,
        name: current_user.username,
      },
      exclude: current_user.webauthn_credentials.pluck(:external_id)
    )

    Webauthn::Challenge.where(user: current_user).map(&:destroy)
    record = Webauthn::Challenge.new(challenge: create_options.challenge, user: current_user)

    if record.save!
      render json: create_options, status: :ok
    else
      render json: {error: record.errors }, status: :unprocessable_entity
    end
  end
end
