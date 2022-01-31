class Poll < ApplicationRecord
  belongs_to :form, class_name: 'Form::Form'
  has_many :responses, through: :form, class_name: 'Form::Response'
  belongs_to :author, class_name: 'User'

  validate :form_has_at_most_one_question
  validate :form_only_has_closed_question

  after_save :copy_author_to_form!

  private

  def copy_author_to_form!
    return unless form

    form.update(author: author)
  end

  def form_has_at_most_one_question
    return if form.try(:closed_questions).try(:size).nil?
    return if form.closed_questions.size <= 1

    errors.add(:form, 'has not exactly one question')
  end

  def form_only_has_closed_question
    return if form.try(:open_questions).try(:empty?)

    errors.add(:form, 'has not only closed questions')
  end
end
