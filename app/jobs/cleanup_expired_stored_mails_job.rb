class CleanupExpiredStoredMailsJob < ApplicationJob
  queue_as :default

  def perform
    # Really destroy already moderated emails older than two weeks
    deleted_mails = StoredMail.only_deleted.where('created_at < ?', 2.weeks.ago)
    deleted_mails_count = deleted_mails.count
    deleted_mails.each(&:really_destroy!) if deleted_mails_count.positive?

    # Delete all expired (ignored) emails after the 3-day threshold imposed by Mailgun
    expired_mails = StoredMail.where('created_at < ?', 3.days.ago)
    expired_mails_count = expired_mails.count
    expired_mails.each(&:destroy) if expired_mails.any?

    inform_slack(deleted_mails_count, expired_mails_count)
  end

  def inform_slack(deleted_count, expired_count)
    if deleted_count.positive? && expired_count.positive?
      SlackMessageJob.perform_later(
        "Email cleanup finished. #{deleted_count} expired emails really destroyed; "\
        "#{expired_count} ignored (not-moderated) emails soft-deleted",
        channel: '#monitoring'
      )
    else
      SlackMessageJob.perform_later('No email cleanup needed', channel: '#monitoring')
    end
  end
end
