FactoryBot.define do
  factory :article do
    author do
      FactoryBot.create(:user)
    end

    group do
      FactoryBot.create(:group,
                        users: [author])
    end

    title { Faker::Book.title }
    content { Faker::Hipster.paragraph(sentence_count: 3) }
    publicly_visible { false }
    pinned { false }

    trait(:public) { publicly_visible { true } }
    trait(:pinned) { pinned { true } }
  end
end
