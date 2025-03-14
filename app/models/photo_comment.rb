class PhotoComment < ApplicationRecord
  has_paper_trail
  belongs_to :photo, touch: true
  counter_culture :photo, column_name: :comments_count
  belongs_to :author, class_name: 'User'

  validates :content, presence: true, length: { minimum: 1, maximum: 500 }

  scope :publicly_visible, lambda {
    joins(:photo_album).where(photo_albums: { visibility: 'everybody' })
  }

  scope :alumni_visible, lambda { |start_date, end_date|
  joins(:photo_album)
    .where(photo_albums: { visibility: 'alumni' })
    .or(photo_albums: { visibility: 'everybody' })
    .or(where.not(photo_albums: { date: nil}).where(photo_albums: { date: start_date..end_date}))
    .or(where(photo_albums: { date: nil }).where(photo_albums: { created_at: start_date..end_date}))
  }
end
