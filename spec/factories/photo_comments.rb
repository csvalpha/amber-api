FactoryBot.define do
  factory :photo_comment do
    content { Faker::Lorem.sentence }
    author do
      FactoryBot.create(:user)
    end

    photo

    trait(:public) { association :photo, :public }
  end
end
