module Form
  class ClosedQuestionOption < ApplicationRecord
    belongs_to :question, class_name: 'ClosedQuestion'
    has_one :form, through: :question
    has_many :answers, class_name: 'ClosedQuestionAnswer', foreign_key: 'option_id'

    validates :option, presence: true
    validates :position, presence: true, numericality: { only_integer: true }

    validate :no_changes_allowed_on_present_responses

    private

    def no_changes_allowed_on_present_responses
      return if !changed? || form.try(:responses).try(:empty?)

      errors.add(:form, 'has any responses')
    end
  end
end
