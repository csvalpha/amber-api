class Webauthn::Challenge < ActiveRecord::Base
  validates :challenge, :user_id, :created_at, presence: true
  validates :challenge, uniqueness: true

  belongs_to :user

  def expired?
    !(Time.zone.now - created_at < 5.minutes)
  end

  after_initialize do
    self.created_at = Time.zone.now
  end
end
