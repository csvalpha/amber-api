FactoryBot.define do
  factory :static_page do
    sequence(:title) { |n| "#{Faker::Book.title} #{n}" }
    content { Faker::Hipster.paragraph(3) }
    publicly_visible { false }
    category { %w[vereniging ict documenten].sample }

    trait(:public) { publicly_visible { true } }
  end
end
