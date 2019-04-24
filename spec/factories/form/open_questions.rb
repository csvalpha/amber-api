FactoryBot.define do
  factory :open_question, class: Form::OpenQuestion do
    question { Faker::Lorem.sentence }
    field_type { %w[text textarea].sample }
    required { Faker::Boolean.boolean }
    position { Faker::Number.digit }
    form

    factory :open_question_number, class: Form::OpenQuestion do
      field_type { :number }
    end
  end
end
