class PhotoTag < ApplicationRecord
  belongs_to :photo, touch: true
  counter_culture :photo, column_name: :tags_count
  belongs_to :author, class_name: 'User'
  belongs_to :tagged_user, class_name: 'User'

  validates :x, inclusion: { in: 0.0..100.0 }
  validates :y, inclusion: { in: 0.0..100.0 }

  validate :user_not_already_tagged

  private

  def user_not_already_tagged
    if PhotoTag.exists?(photo_id: photo_id, tagged_user_id: tagged_user_id)
      errors.add(:tagged_user, 'has already been tagged in this photo')
    end
  end
end
