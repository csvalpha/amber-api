FactoryBot.define do
  factory :open_question_answer, class: 'Form::OpenQuestionAnswer' do
    answer { Faker::Lorem.sentence }
    question factory: %i[open_question]
    response { FactoryBot.create(:response, form: question.form) }
  end
end
