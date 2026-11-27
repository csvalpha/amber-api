class UserCleanupJob < ApplicationJob
  queue_as :default

  def perform # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    will_remove_users = []
    removed_users = []

    User.select { |u| u.active_groups.empty? }.each do |user|
      last_active_group = user.memberships.order(:end_date).last
      next if last_active_group.nil?

      if last_active_group.end_date < 20.months.ago
        removed_users << user if archive_user(user)
      elsif last_active_group.end_date < 18.months.ago
        will_remove_users << user
      end
    end

    if removed_users.any? || will_remove_users.any?
      UserCleanupMailer.cleanup_email(will_remove_users, removed_users).deliver_now
    end
    HealthCheckJob.perform_now(:user_cleanup)
  end

  private

  # A single user that fails to archive should not prevent all other users from being archived
  def archive_user(user)
    UserArchiveJob.perform_now(user.id)
    true
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { user_id: user.id })
    false
  end
end
