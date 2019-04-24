FactoryBot.define do
  factory :form, class: Form::Form do
    respond_from { Faker::Time.between(1.month.ago, Date.yesterday, :day) }
    respond_until { Faker::Time.between(Date.tomorrow, 7.days.from_now, :day) }

    trait :with_author do
      association :author, factory: :user
    end

    factory :expired_form do
      respond_from { Faker::Time.between(1.month.ago, 2.weeks.ago, :day) }
      respond_until { Faker::Time.between(1.week.ago, Date.yesterday, :day) }
    end

    factory :unpublished_form do
      respond_from { Faker::Time.between(Date.tomorrow, 1.week.from_now, :day) }
      respond_until { Faker::Time.between(2.weeks.from_now, 1.month.from_now, :day) }
    end
  end
end
