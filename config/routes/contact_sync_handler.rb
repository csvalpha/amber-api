class ContactSyncHandler < DAV4RackExt::Handler
  def initialize(options = {}) # rubocop:disable Style/OptionHash
    super(default_options.merge(options))
  end

  def call(env)
    super(env)
  rescue ActiveRecord::RecordNotFound
    Rack::Response.new([], 404).finish
  end

  def default_options
    {
      dav_extensions: DAV4Rack::Carddav::DAV_EXTENSIONS,
      controller_class: DAV4Rack::Carddav::Controller,
      logger: ::Logger.new('/dev/null'),
      always_include_dav_header: true,
      pretty_xml: true,
      root_uri_path: ->(env) { root_uri_path(env) },
      current_user: ->(env) { current_webdav_user(env) }
    }
  end

  def root_uri_path(env)
    path = env['PATH_INFO']
    path[0...(path.index('/contacts') + 9)]
  end

  def current_webdav_user(env)
    params = request_params(env)
    user = user(params[:user_id], params[:key])
    webdav_user = Webdav::User.new(user, params[:book_id])
    if params[:contact_id]
      webdav_user.current_contact =
        webdav_user.current_addressbook.find_contact(params[:contact_id])
    end
    webdav_user
  end

  def request_params(env)
    {
      user_id: env['action_dispatch.request.path_parameters'][:user_id],
      key: env['action_dispatch.request.path_parameters'][:key],
      contact_id: env['action_dispatch.request.path_parameters'][:contact_id],
      book_id: env['action_dispatch.request.path_parameters'][:book_id]
    }
  end

  def user(user_id, key)
    user = User.activated.login_enabled.find_by(id: user_id, webdav_secret_key: key)
    raise ActiveRecord::RecordNotFound unless user

    user
  end
end
