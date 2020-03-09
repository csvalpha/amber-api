module Forum
  class Thread < ApplicationRecord
    has_many :posts, dependent: :destroy, counter_cache: :posts_count
    has_many :unread_threads, dependent: :destroy

    belongs_to :author, class_name: 'User'
    belongs_to :category, touch: true
    counter_culture :category, column_name: :threads_count

    validates :title, presence: true
    validates :author, presence: true
    validates :category, presence: true

    def closed?
      !closed_at.nil?
    end

    def last_post
      self.posts.last
    end

    def mark_read(user)
      # Group.active_groups_for_user(self).include?(group)
      unread_thread = Forum::UnreadThread.find_or_create_by(thread: self, user: user)
      unread_thread.post = self.last_post
    end

    def read(user)
      thread = Forum::UnreadThread.find_or_create_by(thread: self, user: user)
      thread.post != nil && thread.post == self.last_post
    end
  end
end
