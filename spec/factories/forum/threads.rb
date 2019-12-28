FactoryBot.define do
  factory :thread, class: 'Forum::Thread' do
    title { Faker::Hipster.sentence(word_count: 4, supplemental: true, random_words_to_add: 2) }
    association :author, factory: :user
    category

    trait(:closed) do
      closed_at { Time.zone.now }
    end
  end
end
