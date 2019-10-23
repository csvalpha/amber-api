class CleanupExpiredStoredMailsJob < ApplicationJob
  queue_as :default

  def perform
    # Really destroy already moderated emails older than four weeks
    deleted_mails = StoredMail.only_deleted.where('created_at <= ?', 4.weeks.ago)
    deleted_mails_count = deleted_mails.count
    deleted_mails.each(&:really_destroy!)

    # Delete all expired (ignored) emails after the 3-day threshold imposed by Mailgun
    expired_mails = StoredMail.where('created_at <= ?', 4.days.ago)
    expired_mails_count = expired_mails.count
    expired_mails.each(&:destroy)

    inform_slack(deleted_mails_count, expired_mails_count)
  end

  def inform_slack(deleted_count, expired_count)
    return unless deleted_count.positive? || expired_count.positive?

    SlackMessageJob.perform_later(
      "Email cleanup finished. #{deleted_count} expired #{'emails'.pluralize(deleted_count)} "\
      "really destroyed; #{expired_count} ignored (not-moderated) "\
      "#{'emails'.pluralize(expired_count)} soft-deleted",
      channel: '#monitoring'
    )
  end
end
