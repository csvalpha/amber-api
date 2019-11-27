FactoryBot.define do
  factory :closed_question_answer, class: 'Form::ClosedQuestionAnswer' do
    option do
      FactoryBot.create(:closed_question_option,
                        question: FactoryBot.create(:closed_question,
                                                    form: FactoryBot.create(:form)))
    end
    response do
      FactoryBot.create(:response,
                        form: (option.try(:question).try(:form) || FactoryBot.create(:form)))
    end
  end
end
