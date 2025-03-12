FactoryBot.define do
  factory :article_comment do
    content { Faker::Lorem.sentence }
    author do
      FactoryBot.create(:user)
    end

    article

    trait(:with_public_article) { article factory: %i[article public] }
  end
end
