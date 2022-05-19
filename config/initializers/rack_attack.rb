# See https://github.com/kickstarter/rack-attack/wiki/Example-Configuration
module Rack
  class Attack
    # Throttle all requests by IP (100rpm)
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
    throttle('req/ip', limit: 500, period: 5.minutes, &:ip)

    # Throttle POST requests to /oauth/token by IP address
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
    throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
      req.ip if req.path == '/oauth/token'
    end

    # Throttle POST requests to /oauth/token by username param
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/username:#{req.username}"
    #
    # Note: This creates a problem where a malicious user could intentionally
    # throttle logins for another user and force their login requests to be
    # denied, but that's not very common and shouldn't happen to you. (Knock
    # on wood!)
    throttle('logins/username', limit: 5, period: 20.seconds) do |req|
      req.params['username'].presence if req.path == '/oauth/token'
    end

    self.throttled_responder = lambda do |req|
      now = Time.zone.now
      match_data = req.env['rack.attack.match_data']

      headers = {
        'X-RateLimit-Limit' => match_data[:limit].to_s,
        'X-RateLimit-Remaining' => '0',
        'X-RateLimit-Reset' =>
          (now + (match_data[:period] - (now.to_i % match_data[:period]))).to_s,
        'Content-Type' => 'application/json; charset=utf-8'
      }

      [429, headers, [{ errors: {} }.to_json]]
    end
  end
end
