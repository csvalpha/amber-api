class CleanupExpiredStoredMailsJob < ApplicationJob
  queue_as :default

  def perform
    # Really destroy already moderated emails older than two weeks
    deleted_mails = StoredMail.only_deleted.where('created_at < ?', 2.weeks.ago)
    deleted_mails_count = deleted_mails.count
    deleted_mails.really_destroy!

    # Delete all expired (ignored) emails after the 3-day threshold imposed by Mailgun
    expired_mails = StoredMail.where('created_at < ?', 3.days.ago)
    expired_mails_count = expired_mails.count
    expired_mails.destroy

    inform_slack(deleted_mails_count, expired_mails_count)
  end

  def inform_slack(deleted_count, expired_count)
    SlackMessageJob.perform_later(
      "Cleanup finished. #{deleted_count} expired emails really destroyed; "\
      "#{expired_count} ignored (not-moderated) emails soft-deleted",
      channel: '#monitoring'
    )
  end
end
