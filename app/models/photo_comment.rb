class PhotoComment < ApplicationRecord
  has_paper_trail
  belongs_to :photo, touch: true
  counter_culture :photo, column_name: :comments_count
  belongs_to :author, class_name: 'User'

  validates :content, presence: true, length: { minimum: 1, maximum: 500 }

  scope :publicly_visible, (lambda {
    joins(:photo_album).where(photo_albums: { visibility: "everybody" })
  })

  scope :alumni_visible, (lambda {
    joins(:photo_album).where(photo_albums: { visibility: "alumni" })
  })
end
