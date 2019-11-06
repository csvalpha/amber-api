require 'http'

class MailReceiveJob < ApplicationJob
  queue_as :mail_handlers

  def perform(recipients, message_url) # rubocop:disable Metrics/MethodLength
    fetched_mail = MailgunFetcher::Mail.new(message_url)
    mail_aliases = gather_valid_aliases(recipients, fetched_mail)
    return unless mail_aliases.any?

    mail_aliases.each do |mail_alias|
      if mail_alias.moderation_type == 'open' || (mail_alias.moderation_type == 'semi_moderated' &&
        mail_alias.mail_addresses.include?(fetched_mail.sender))
        MailForwardJob.perform_later(mail_alias, message_url)
      else
        send_mail_moderations(mail_alias, message_url, fetched_mail)
      end
    end
  end

  def send_mail_moderations(mail_alias, message_url, fetched_mail)
    stored_mail = StoredMail.create(message_url: message_url, received_at: fetched_mail.received_at,
                                    sender: fetched_mail.sender, mail_alias: mail_alias,
                                    subject: fetched_mail.subject)

    mail_alias.moderators.each do |moderator|
      MailModerationMailer.request_for_moderation_email(moderator, stored_mail).deliver_later
    end
    MailModerationMailer.awaiting_moderation_email(stored_mail.sender, stored_mail).deliver_later
  end

  private

  def gather_valid_aliases(recipients, fetched_mail) # rubocop:disable Metrics/AbcSize
    mail_aliases = []
    recipients.split(', ').each do |recipient|
      next unless Rails.application.config.x.mail_domains.include?(recipient.split('@')[1])

      mail_alias = MailAlias.where(email: recipient.downcase).first
      mail_aliases.push(mail_alias) if mail_alias
      notify_unknown_address(fetched_mail.sender, recipient) unless mail_alias
    end
    mail_aliases
  end

  def notify_unknown_address(sender, recipient)
    send_slack_message("#{sender} send an email to #{recipient}, "\
                                'but that alias does not exists.'\
                                ' Sender is informed.')

    return if sender.include?('no-reply') || sender.include?('noreply')

    MailBounceMailer.address_unknown(sender, recipient).deliver_later
  end

  # :nocov:
  def send_slack_message(message)
    return unless Rails.env.production? || Rails.env.staging?

    SlackMessageJob.perform_later(message, channel: '#mail')
  end
  # :nocov:
end
