class PhotoComment < ApplicationRecord
  has_paper_trail
  belongs_to :photo, touch: true
  counter_culture :photo, column_name: :comments_count
  belongs_to :author, class_name: 'User'

  validates :content, presence: true, length: { minimum: 1, maximum: 500 }

  scope :alumni_visible, lambda { |start_date, end_date|
    joins(photo: :photo_album)
      .where(photo_album: { visibility: %w[alumni public] })
      .or(where.not(photo_album: { date: nil }).where(photo_album: { date: start_date..end_date }))
      .or(where(photo_album: { date: nil }).where(photo_album: { created_at: start_date..end_date }))
  }
end
