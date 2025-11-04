OTP_HEADER = 'X-Amber-OTP'.freeze

Doorkeeper.configure do # rubocop:disable Metrics/BlockLength
  orm :active_record
  api_only
  use_refresh_token

  hash_token_secrets
  hash_application_secrets

  optional_scopes :sofia

  # See https://github.com/doorkeeper-gem/doorkeeper/wiki/Using-Resource-Owner-Password-Credentials-flow
  grant_flows %w[password authorization_code client_credentials]

  resource_owner_from_credentials do
    user = User.activated.login_enabled.find_by(username: params[:username])

    if user.try(:authenticate, params[:password])
      if user.otp_required?
        one_time_password = request.headers[OTP_HEADER]
        if !one_time_password
          response.headers[OTP_HEADER] = 'required'
          nil
        elsif user.authenticate_otp(one_time_password, drift: 10)
          user
        else
          response.headers[OTP_HEADER] = 'invalid'
          nil
        end
      else
        user
      end
    end
  end

  resource_owner_authenticator do
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # https://github.com/doorkeeper-gem/doorkeeper/blob/v5.4.0/app/controllers/doorkeeper/authorizations_controller.rb#L123
  after_successful_authorization do |_, auth|
    # To SOFIA, a CodeResponse is returned
    if auth.auth.is_a?(Doorkeeper::OAuth::CodeResponse)
      # We are only interested authorization for the sofia scope
      # Check if either 'sofia' is included in the scopes
      is_sofia = auth.auth.pre_auth.scopes.include?('sofia')
      user = auth.auth.pre_auth.resource_owner

      if is_sofia && !user.allow_sofia_sharing
        user.allow_sofia_sharing = true
        user.save!
      end
    end
  end
end
