FactoryBot.define do
  factory :mandate, class: 'Debit::Mandate' do
    start_date { Faker::Date.between(12.months.ago, 1.month.ago) }
    iban_holder { Faker::Name.first_name }
    iban do
      %w[NL02ABNA0123456789 NL69INGB0123456789 NL44RABO0123456789
         NL12SNSB0123456789 NL13TEST0123456789].sample
    end
    user
  end
end
