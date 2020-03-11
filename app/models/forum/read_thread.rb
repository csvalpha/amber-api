module Forum
  class ReadThread < ApplicationRecord
    belongs_to :user
    belongs_to :thread
    belongs_to :post

    validates :user_id, presence: true
    validates :thread_id, presence: true
  end
end
