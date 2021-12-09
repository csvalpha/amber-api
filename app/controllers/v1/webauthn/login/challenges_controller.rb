class V1::Webauthn::Login::ChallengesController < V1::ApplicationController
  skip_before_action :doorkeeper_authorize!

  def create # rubocop:disable Metrics/MethodLength
    user = User.find_by(username: params[:username])

    unless user
      head :forbidden
      return
    end

    get_options = WebAuthn::Credential.options_for_get(
      allow: user.webauthn_credentials.pluck(:external_id)
    )

    Webauthn::Challenge.where(user: user).map(&:destroy)
    record = Webauthn::Challenge.new(challenge: get_options.challenge, user: user)

    if record.save!
      render json: get_options, status: :ok
    else
      render json: { error: record.errors }, status: :unprocessable_entity
    end
  end
end
