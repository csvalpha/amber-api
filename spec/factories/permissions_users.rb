FactoryBot.define do
  factory :permissions_users do
    user

    transient do
      permission_name { FactoryBot.attributes_for(:permission)[:name] }
    end

    after :build do |permissions_users, evaluator|
      permissions_users.permission = FactoryBot.create(:permission,
                                                       name: evaluator.permission_name)
    end
  end
end
