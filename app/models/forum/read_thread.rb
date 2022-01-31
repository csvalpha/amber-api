module Forum
  class ReadThread < ApplicationRecord
    belongs_to :user
    belongs_to :thread
    belongs_to :post
  end
end
