module Form
  class Response < ApplicationRecord
    belongs_to :form
    counter_culture :form, column_name: :responses_count
    belongs_to :user
    has_many :open_question_answers, dependent: :destroy
    has_many :open_questions, through: :open_question_answers, source: :question
    has_many :closed_question_answers, dependent: :destroy
    has_many :closed_questions, through: :closed_question_answers, source: :question

    validates :user, uniqueness: { scope: :form, unless: -> { !user.id.nil? && user.id.zero? } }
    validate :form_allows_responses?

    after_create :update_completed_status!
    before_destroy :destroyable?

    scope :completed, (-> { where(completed: true) })

    def complete
      reload unless new_record? # reloading is necessary, to make sure all associations are fresh
      return false unless form

      (form.open_questions.required - open_questions).empty? &&
        (form.closed_questions.required - closed_questions).empty?
    end

    def update_completed_status!
      tries ||= 3
      update(completed: complete)
    rescue ActiveRecord::StaleObjectError => e
      retry if (tries -= 1).positive?
      raise e
    end

    private

    def destroyable?
      throw(:abort) unless form_allows_responses?
    end

    def form_allows_responses?
      return true if form.try(:allows_responses?)

      errors.add(:form, 'does not allow responses')
      false
    end
  end
end
