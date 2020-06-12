FactoryBot.define do
  factory :application, class: 'Doorkeeper::Application' do
    name { Faker::Book.title }
    redirect_uri { 'https://localhost' }
  end
end
