FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    description { Faker::Hipster.paragraph(sentence_count: 3) }
    isbn { Faker::Code.isbn }
  end
end
