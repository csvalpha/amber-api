module Vote
  class Response < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    belongs_to :form

    validates :form, presence: true
  end
end
