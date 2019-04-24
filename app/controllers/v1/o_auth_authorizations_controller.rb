class V1::OAuthAuthorizationsController < V1::ApplicationController
  include Doorkeeper::Helpers::Controller
  before_action :doorkeeper_authorize!, except: [:new]

  def new
    default_options = Rails.application.config.action_mailer.default_url_options
    url = URI::Generic.build(default_options).merge(request.fullpath.split('/v1/')[1]).to_s

    redirect_to(url)
  end

  def auth_code_redirect_uri
    auth = authorization.authorize

    response = {}
    response[:error] = auth.try(:name)
    response[:redirect_uri] = auth.redirect_uri unless response[:error]

    render json: { auth: response.to_json }
  end

  # See https://github.com/doorkeeper-gem/doorkeeper/blob/master/
  #     app/controllers/doorkeeper/authorizations_controller.rb
  def pre_auth
    @pre_auth ||= Doorkeeper::OAuth::PreAuthorization.new(Doorkeeper.configuration,
                                                          server.client_via_uid,
                                                          params)
  end

  def authorization
    @authorization ||= strategy.request
  end

  def strategy
    @strategy ||= server.authorization_request pre_auth.response_type
  end
end
