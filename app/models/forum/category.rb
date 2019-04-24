module Forum
  class Category < ApplicationRecord
    has_many :threads, dependent: :destroy, counter_cache: :threads_count

    validates :name, presence: true
  end
end
