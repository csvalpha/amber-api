FactoryBot.define do
  factory :response, class: 'Form::Response' do
    form
    user
  end
end
