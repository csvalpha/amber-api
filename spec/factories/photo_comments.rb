FactoryBot.define do
  factory :photo_comment do
    content { Faker::Lorem.sentence }
    author do
      FactoryBot.create(:user)
    end

    photo

    trait(:alumni) { photo factory: %i[photo alumni] }
  end
end
