module Forum
  class Thread < ApplicationRecord
    has_paper_trail
    has_many :posts, dependent: :destroy, counter_cache: :posts_count
    has_many :read_threads, dependent: :destroy

    belongs_to :author, class_name: 'User'
    belongs_to :category, touch: true
    counter_culture :category, column_name: :threads_count

    validates :title, presence: true

    def closed?
      !closed_at.nil?
    end

    def read?(user)
      thread = Forum::ReadThread.find_or_create_by(thread: self, user:)
      thread.post == posts.last
    end
  end
end
