class Article < ApplicationRecord
  mount_base64_uploader :cover_photo, CoverPhotoUploader
  has_paper_trail skip: [:cover_photo]

  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true
  has_many :comments, class_name: 'ArticleComment', dependent: :destroy,
                      counter_cache: :comments_count

  validates :title, presence: true
  validates :content, presence: true
  validates :publicly_visible, inclusion: [true, false]
  validates :pinned, inclusion: [true, false]

  validate :only_one_pinned_article

  scope :publicly_visible, -> { where(publicly_visible: true) }
  scope :pinned, -> { where(pinned: true) }

  def owners
    if group.present?
      group.active_users + [author]
    else
      [author]
    end
  end

  private

  def only_one_pinned_article
    return unless pinned?

    matches = Article.pinned.where.not(id:)
    errors.add(:pinned, 'cannot have more than one pinned article') if matches.exists?
  end
end
