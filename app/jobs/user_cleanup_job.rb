class UserCleanupJob < ApplicationJob
  queue_as :default

  def perform # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    will_remove_users = []
    removed_users = []

    User.where(archived_at: nil).select { |u| u.active_groups.empty? }.each do |user|
      last_active_group = user.memberships.order(:end_date).last
      next if last_active_group.nil?

      if last_active_group.end_date < 20.months.ago
        removed_users << user
        user.archive!
      elsif last_active_group.end_date < 18.months.ago
        will_remove_users << user
      end
    end

    UserCleanupMailer.cleanup_email(will_remove_users, removed_users).deliver_now
  end
end
