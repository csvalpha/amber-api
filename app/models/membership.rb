class Membership < ApplicationRecord
  has_paper_trail
  belongs_to :group
  belongs_to :user

  validates :start_date, presence: true
  validates_date :start_date
  validates_date :end_date, after: :start_date, allow_nil: true

  validate :unique_on_time_interval?

  after_commit :sync_mail_aliases

  scope :active, lambda {
    where('memberships.start_date <= :now AND
               (memberships.end_date > :now OR memberships.end_date IS NULL)',
          now: Time.zone.now)
  }

  private

  def unique_on_time_interval?
    return true unless Membership.where.not(id: id)
                                 .where(group_id: group_id, user_id: user_id)
                                 .exists?([<<-SQL, { start_date: start_date, end_date: end_date }])
        CAST(:start_date AS date) BETWEEN start_date AND end_date OR
        CAST(:end_date AS date) BETWEEN start_date AND end_date OR
        start_date BETWEEN CAST(:start_date AS date) AND CAST(:end_date AS date) OR
        end_date BETWEEN CAST(:start_date AS date) AND CAST(:end_date AS date) OR
        (start_date < CAST(:start_date AS date) AND end_date IS NULL) OR
        (start_date > CAST(:start_date AS date) AND CAST(:end_date AS date) IS NULL)
      SQL
  
    errors.add(:membership, 'is not unique on time interval')
    false
  end

  # Remark, this will cause multiple updates when adding multiple users after each other
  # But this is quite hard to fix, but just be carefull
  # :nocov:
  def sync_mail_aliases
    return unless Rails.env.production? || Rails.env.staging?
    return if group.mail_aliases.empty?

    MailAliasSyncJob.perform_later(group.mail_aliases.ids)
  end
  # :nocov:
end
