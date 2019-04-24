JSONAPI.configure do |config|
  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor

  # By default an exception will return a 500, when you want to handle the error in the controller
  # you have to specifiy it here
  config.exception_class_whitelist = [Pundit::NotAuthorizedError,
                                      AmberError::NotMemberOfGroupError]

  # Do not raise an error when unpermitted paramaters are passed.
  # Instead add warnings in the metadata
  config.raise_if_parameters_not_allowed = false

  config.json_key_format = :underscored_key
  config.route_format = :underscored_route

  # Pagination
  config.top_level_meta_include_page_count = true
  config.default_paginator = :default_off
  config.maximum_page_size = 50
end
