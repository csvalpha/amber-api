class ArticleComment < ApplicationRecord
  belongs_to :article
  counter_culture :article, column_name: :comments_count
  belongs_to :author, class_name: 'User'

  validates :content, presence: true, length: { minimum: 1, maximum: 500 }

  scope :publicly_visible, (lambda {
    joins(:article).where(articles: { publicly_visible: true })
  })
end
