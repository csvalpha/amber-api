class UserCleanupJob < ApplicationJob
  queue_as :default
  DESTROY_RELATIONSHIPS = [:board_room_presences]

  def perform
    will_remove_users = []
    removed_users = []

    User.where(archived_at: nil).select{|u| u.active_groups.size == 0}.each do |user|
      last_active_group = user.memberships.order(:end_date).last
      return if last_active_group.nil?

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
