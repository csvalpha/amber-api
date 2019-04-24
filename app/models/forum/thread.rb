module Forum
  class Thread < ApplicationRecord
    has_many :posts, dependent: :destroy, counter_cache: :posts_count
    belongs_to :author, class_name: 'User'
    belongs_to :category, touch: true
    counter_culture :category, column_name: :threads_count

    validates :title, presence: true
    validates :author, presence: true
    validates :category, presence: true

    def closed?
      !closed_at.nil?
    end
  end
end
