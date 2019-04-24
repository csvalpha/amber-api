class SlackMessageJob < ApplicationJob
  include SlackHelper
  queue_as :default

  def perform(message, channel: nil)
    ping(message, channel: channel)
  end
end
