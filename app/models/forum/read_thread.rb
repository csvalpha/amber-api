module Forum
  class ReadThread < ApplicationRecord
    belongs_to :user
    belongs_to :thread
    belongs_to :post

    validates :user, presence: true
    validates :thread, presence: true
  end
end
