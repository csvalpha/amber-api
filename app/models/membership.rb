class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :group, presence: true
  validates :user, presence: true
  validates :start_date, presence: true
  validates_date :start_date
  validates_date :end_date, after: :start_date, allow_nil: true

  validate :unique_on_time_interval?

  scope :active, (lambda {
    where('memberships.start_date <= :now AND
               (memberships.end_date > :now OR memberships.end_date IS NULL)',
          now: Time.zone.now)
  })

  private

  def unique_on_time_interval? # rubocop:disable Metrics/MethodLength
    return true unless Membership.where.not(id: id)
                                 .where(group_id: group_id, user_id: user_id)
                                 .where(':start_date BETWEEN start_date AND end_date OR
                                        :end_date BETWEEN start_date AND end_date OR
                                        start_date BETWEEN :start_date AND :end_date OR
                                        end_date BETWEEN :start_date AND :end_date OR
                                        (start_date < :start_date AND end_date IS NULL) OR
                                        (start_date > :start_date AND :end_date IS NULL)',
                                        start_date: start_date, end_date: end_date).exists?

    errors.add(:membership, 'is not unique on time interval')
    false
  end
end
