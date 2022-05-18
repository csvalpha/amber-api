FactoryBot.define do
  factory :group do
    name { Faker::Team.name }
    description { Faker::Lorem.paragraph }
    kind do
      %w[bestuur commissie dispuut genootschap groep huis jaargroep werkgroep kring lichting].sample
    end
    recognized_at_gma { 'ALV 21' }
    rejected_at_gma { 'ALV 218' }
    administrative { Faker::Boolean }

    transient do
      users { [] }
      permission_list { [] }
    end

    trait :with_user do
      users { [FactoryBot.create(:user)] }
    end

    after :create do |group, evaluator|
      group.memberships << evaluator.users.compact.map do |user|
        FactoryBot.create(:membership, user:, group:)
      end
      group.permissions << evaluator.permission_list.compact.map do |name|
        FactoryBot.create(:permission, name:)
      end
    end
  end
end
