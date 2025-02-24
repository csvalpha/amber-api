class PhotoTag < ApplicationRecord
  has_paper_trail
  belongs_to :photo, touch: true
  counter_culture :photo, column_name: :tags_count
  belongs_to :author, class_name: 'User'
  belongs_to :tagged_user, class_name: 'User'

  validates :x, inclusion: { in: 0.0..100.0 }
  validates :y, inclusion: { in: 0.0..100.0 }

  validate :user_not_already_tagged

  private

  def user_not_already_tagged
    existing_tag = PhotoTag.where(photo_id:, tagged_user_id:).where.not(id:).exists?
    errors.add(:tagged_user, 'has already been tagged in this photo') if existing_tag
  end
end
