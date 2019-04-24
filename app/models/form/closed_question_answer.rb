module Form
  class ClosedQuestionAnswer < QuestionAnswer
    belongs_to :option, class_name: 'ClosedQuestionOption'
    belongs_to :question, class_name: 'ClosedQuestion'

    validates :option, presence: true
    validates :response, presence: true, uniqueness: { scope: :option }
    validates :question, uniqueness: { scope: :response }, if: :radio_question?
    validate :option_belongs_to_question?
    validate :radio_question_reflects_question?

    def option=(value)
      super(value)
      self.question = option.try(:question)
      self.radio_question = radio_question?
    end

    def option_id=(value)
      super(value)
      self.option = ClosedQuestionOption.find(value) if value
    end

    private

    def radio_question?
      question.try(:radio_question?)
    end

    def option_belongs_to_question?
      return true if question == option.try(:question)

      errors.add(:option, 'does not belong to question')
      false
    end

    def radio_question_reflects_question?
      return true if radio_question == radio_question?

      errors.add(:radio_question, 'is not equal to field type of question')
      false
    end
  end
end
