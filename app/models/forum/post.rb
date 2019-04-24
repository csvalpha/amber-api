module Forum
  class Post < ApplicationRecord
    belongs_to :author, class_name: 'User'
    belongs_to :thread, touch: true
    counter_culture :thread, column_name: :posts_count

    validates :message, presence: true
    validates :author, presence: true
    validates :thread, presence: true
  end
end
