class Article < ApplicationRecord
  mount_base64_uploader :cover_photo, CoverPhotoUploader
  has_paper_trail skip: [:cover_photo]

  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true
  has_many :comments, class_name: 'ArticleComment', dependent: :destroy,
                      counter_cache: :comments_count

  validates :author, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates :publicly_visible, inclusion: [true, false]

  scope :publicly_visible, (-> { where(publicly_visible: true) })

  def owners
    if group.present?
      group.active_users + [author]
    else
      [author]
    end
  end
end
