FactoryBot.define do
  factory :permission do
    name { %w[activity.create article.update group.read user.destroy].sample }
  end
end
