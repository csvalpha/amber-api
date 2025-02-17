class AuthConstraint
  def self.sidekiq?(request)
    return false if request.cookie_jar['ember_simple_auth-session'].blank?

    token = JSON.parse(request.cookie_jar['ember_simple_auth-session']).dig('authenticated',
                                                                            'access_token')
    Rails.cache.fetch(token, expires_in: 1.minute) do
      user_id = Doorkeeper::AccessToken.by_token(token).resource_owner_id
      user = User.find_by(id: user_id)

      user&.permission?("read", "Sidekiq")
    end
  end
end
