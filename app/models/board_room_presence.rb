class BoardRoomPresence < ApplicationRecord
  belongs_to :user

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates_datetime :end_time, after: :start_time
  validates :status, inclusion: { in: %w[present busy absent] }

  scope :current, (lambda {
    where('start_time <= :current_time AND end_time >= :current_time',
          current_time: Time.current)
  })
  scope :future, (lambda {
    where('start_time >= :current_time', current_time: Time.current)
  })
  scope :current_and_future, (lambda {
    where('(start_time <= :current_time AND end_time >= :current_time)
or (start_time >= :current_time)', current_time: Time.current)
  })
end
