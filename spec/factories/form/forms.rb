FactoryBot.define do
  factory :form, class: 'Form::Form' do
    respond_from { Faker::Time.between(from: 1.month.ago, to: Date.yesterday) }
    respond_until { Faker::Time.between(from: Date.tomorrow, to: 7.days.from_now) }

    trait :with_author do
      author factory: %i[user]
    end

    factory :expired_form do
      respond_from { Faker::Time.between(from: 1.month.ago, to: 2.weeks.ago) }
      respond_until { Faker::Time.between(from: 1.week.ago, to: Date.yesterday) }
    end

    factory :unpublished_form do
      respond_from { Faker::Time.between(from: Date.tomorrow, to: 1.week.from_now) }
      respond_until { Faker::Time.between(from: 2.weeks.from_now, to: 1.month.from_now) }
    end
  end
end
