module Form
  class ClosedQuestion < ApplicationRecord
    belongs_to :form
    has_many :options, class_name: 'ClosedQuestionOption', dependent: :destroy,
                       foreign_key: 'question_id'
    has_many :answers, class_name: 'ClosedQuestionAnswer', through: :options

    validates :question, presence: true
    validates :field_type, inclusion: %w[checkbox radio]
    validates :required, inclusion: [true, false]
    validates :position, presence: true, numericality: { only_integer: true }

    validate :no_changes_allowed_on_present_responses

    scope :required, (-> { where(required: true) })

    def radio_question?
      field_type == 'radio'
    end

    private

    def no_changes_allowed_on_present_responses
      return if !changed? || form.try(:responses).try(:empty?)

      errors.add(:form, 'has any responses')
    end
  end
end
