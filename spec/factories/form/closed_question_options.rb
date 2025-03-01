FactoryBot.define do
  factory :closed_question_option, class: 'Form::ClosedQuestionOption' do
    option { Faker::Lorem.sentence }
    position { Faker::Number.digit }
    question factory: %i[closed_question]
  end
end
