module Vote
  class Respondent < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    belongs_to :form
    belongs_to :respondent, class_name: 'User'

    validates :form, presence: true
    validates :respondent, presence: true, uniqueness: { scope: :form }
  end
end
