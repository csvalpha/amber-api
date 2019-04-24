class StaticPage < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged history finders]

  validates :title, presence: true
  validates :slug, presence: true
  validates :content, presence: true
  validates :publicly_visible, inclusion: [true, false]
  validates :category, inclusion: %w[vereniging ict documenten]

  scope :publicly_visible, (-> { where(publicly_visible: true) })
end
