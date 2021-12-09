MFA_HEADER = 'X-Amber-MFA'.freeze
MFA_METHODS_HEADER = 'X-Amber-MFA-Methods'.freeze
MFA_ERROR_HEADER = 'X-Amber-MFA-Error'.freeze

def check_webauthn(data, user) # rubocop:disable Metrics/MethodLength
  webauthn_credential = WebAuthn::Credential.from_get(data)
  challenge = Webauthn::Challenge.find_by(user: user)
  external_id = Base64.strict_encode64(webauthn_credential.raw_id)
  credential = user.webauthn_credentials.find_by(external_id: external_id)

  return false if challenge.nil? || challenge.expired?

  begin
    webauthn_credential.verify(
      challenge.challenge,
      public_key: credential.public_key,
      sign_count: credential.sign_count
    )

    credential.update!(sign_count: webauthn_credential.sign_count)

    return true
  rescue WebAuthn::Error
    # Ignored
  ensure
    challenge.destroy
  end

  false
end

Doorkeeper.configure do # rubocop:disable Metrics/BlockLength
  orm :active_record
  api_only
  use_refresh_token

  hash_token_secrets
  hash_application_secrets

  optional_scopes :tomato

  # See https://github.com/doorkeeper-gem/doorkeeper/wiki/Using-Resource-Owner-Password-Credentials-flow
  grant_flows %w[password authorization_code client_credentials]

  # rubocop:disable Metrics/BlockNesting
  resource_owner_from_credentials do
    user = User.activated.login_enabled.find_by(username: params[:username])

    if user.try(:authenticate, params[:password])
      if user.mfa_required?
        response.headers[MFA_HEADER] = 'required'
        response.headers[MFA_METHODS_HEADER] = user.mfa_methods.join(',')

        if params[:webauthn]
          webauthn_data = JSON.parse params[:webauthn]
          if check_webauthn(webauthn_data, user)
            user
          else
            response.headers[MFA_ERROR_HEADER] = 'webauthn_failed'
            nil
          end
        elsif params[:otp]
          if user.authenticate_otp(params[:otp], drift: 10)
            user
          else
            response.headers[MFA_ERROR_HEADER] = 'otp_failed'
            nil
          end
        end
      else
        user
      end
    end
  end
  # rubocop:enable Metrics/BlockNesting

  resource_owner_authenticator do
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
