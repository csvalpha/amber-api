class Vacancy < ApplicationRecord
  mount_base64_uploader :cover_photo, CoverPhotoUploader

  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true

  validates :title, presence: true
  validates :description, presence: true

  def owners
    if group.present?
      group.active_users + [author]
    else
      [author]
    end
  end
end
