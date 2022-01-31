module Form
  class OpenQuestion < ApplicationRecord
    belongs_to :form
    has_many :answers, class_name: 'OpenQuestionAnswer', foreign_key: 'question_id'

    validates :question, presence: true
    validates :field_type, inclusion: %w[number text textarea]
    validates :required, inclusion: [true, false]
    validates :position, presence: true, numericality: { only_integer: true }

    validate :no_changes_allowed_on_present_responses

    scope :required, (-> { where(required: true) })

    private

    def no_changes_allowed_on_present_responses
      return if !changed? || form.try(:responses).try(:empty?)

      errors.add(:form, 'has any responses')
    end
  end
end
