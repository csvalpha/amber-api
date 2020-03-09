module Forum
  class Category < ApplicationRecord
    belongs_to :user
    belongs_to :thread

    validates :user_id, presence: true
    validates :thread_id, presence: true
    validates :post_id, presence: true  end
end

