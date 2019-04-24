FactoryBot.define do
  factory :closed_question, class: Form::ClosedQuestion do
    question { Faker::Lorem.sentence }
    field_type { %w[checkbox radio].sample }
    required { Faker::Boolean.boolean }
    position { Faker::Number.digit }
    form

    factory :radio_question do
      field_type { 'radio' }
    end

    factory :checkbox_question do
      field_type { 'checkbox' }
    end

    trait :with_options do
      after :create do |closed_question|
        FactoryBot.create_list(:closed_question_option, 2, question: closed_question)
      end
    end
  end
end
