module Form
  class QuestionAnswer < ApplicationRecord
    self.abstract_class = true

    belongs_to :response
    has_one :form, through: :response

    validates :response, presence: true
    validate :form_allows_responses?
    validate :question_belongs_to_form?

    after_commit :update_response_completed_status!
    before_destroy :destroyable?

    private

    def update_response_completed_status!
      response.try(:update_completed_status!)
    end

    def destroyable?
      throw(:abort) unless form_allows_responses?
    end

    def form_allows_responses?
      return true if form.try(:allows_responses?)

      errors.add(:form, 'does not allow responses')
      false
    end

    def question_belongs_to_form?
      return true if form == question.try(:form)

      errors.add(:question, 'does not belong to form')
      false
    end
  end
end
