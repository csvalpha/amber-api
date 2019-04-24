# See https://github.com/getsentry/raven-ruby#async
class SentryJob < ApplicationJob
  queue_as :default

  def perform(event)
    Raven.send_event(event)
  end
end
