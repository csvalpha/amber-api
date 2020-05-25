module Vote
  class Form < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_many :responses
    has_many :respondents

    validates :question, presence: true
  end
end
