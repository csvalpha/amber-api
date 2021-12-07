module V1::Webauthn
  class CredentialsController < V1::ApplicationController
    before_action :doorkeeper_authorize!
    after_action :verify_authorized, only: :create

    def create
      authorize Webauthn::Credential

      if challenge.nil? or challenge.expired?
        head :forbidden
        return
      end

      webauthn_credential = WebAuthn::Credential.from_create(params)

      begin
        webauthn_credential.verify(challenge.challenge)

        credential = current_user.webauthn_credentials.find_or_initialize_by(
          external_id: Base64.strict_encode64(webauthn_credential.raw_id)
        )

        if credential.update!(
          nickname: params[:nickname],
          public_key: webauthn_credential.public_key,
          sign_count: webauthn_credential.sign_count
        )
          render json: { status: "ok" }, status: :ok
        else
          render json: {error: "Couldn't add your Security Key"}, status: :unprocessable_entity
        end
      rescue WebAuthn::Error => e
        render json: {error: "Verification failed: #{e.message}"}, status: :unprocessable_entity
      ensure
        # challenge.destroy!
      end
    end

    private

    def challenge
      @challenge ||= Webauthn::Challenge.find_by(user: current_user)
    end

  end

end
