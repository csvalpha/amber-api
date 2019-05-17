require 'http'

class MailBouncedJob < ApplicationJob
  queue_as :mail_handlers

  def perform(mail)
    @mail = mail
    @headers = mail[:message][:headers]
    handle_complaint if mail[:event] == 'complained'
    handle_permanent if mail[:event] == 'failed' && mail['log-level'] == 'error'
  end

  private

  def handle_complaint
    send_slack_message("User #{@mail[:recipient]} marked mail as spam")
  end

  def handle_permanent # rubocop:disable Metrics/AbcSize
    send_slack_message("Message `#{@headers[:subject]}` from #{@headers[:from]}"\
            " to #{@headers[:to]} (with recipient #{@mail[:recipient]}) has permanent failure,"\
            " reason: #{@mail[:reason]}")
    return if @headers[:from].include?('no-reply') || @headers[:from].include?('noreply')

    MailBounceMailer.mail_bounced(@headers[:from], @headers[:to],
                                  @headers[:subject], @mail[:reason]).deliver_later
  end

  # :nocov:
  def send_slack_message(message)
    return unless Rails.env.production? || Rails.env.staging?

    SlackMessageJob.perform_later(message, channel: '#mail')
  end
  # :nocov:
end
