module Form
  class OpenQuestionAnswer < QuestionAnswer
    belongs_to :question, class_name: 'OpenQuestion'

    validates :answer, presence: true
    validates :answer, presence: true, numericality: true, if: (proc do
      question.try(:field_type) == 'number'
    end)
    validates :response, presence: true, uniqueness: { scope: :question }
  end
end
