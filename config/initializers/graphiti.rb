# frozen_string_literal: true

Graphiti.configure do |config|
  config.pagination_links = true
end

Rails.application.config.after_initialize do
  # Ensure resources are loaded in development
  Rails.application.eager_load! if Rails.env.development?
end
