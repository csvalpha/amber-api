redis_adapter = Rails.application.config_for(:cable)['adapter']

if redis_adapter == 'async'
  MessageBus.configure(backend: :memory)
else
  MessageBus.configure(backend: :redis, redis_config: {
    url: Rails.application.config_for(:cable)['url']
  })
end

MessageBus.group_ids_lookup do |env|
  if env['HTTP_AUTHORIZATION']
    access_token = env['HTTP_AUTHORIZATION'].split.last
    if Doorkeeper::AccessToken.by_token(access_token)
      [0] # use group 0 as global group for all authenticated users
    end
  end
end
