module Forum
  class Post < ApplicationRecord
    has_paper_trail
    belongs_to :author, class_name: 'User'
    belongs_to :thread, touch: true
    counter_culture :thread, column_name: :posts_count

    validates :message, presence: true
  end
end
