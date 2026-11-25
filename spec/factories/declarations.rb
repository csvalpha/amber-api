FactoryBot.define do
  factory :declaration do
    user
    amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    description { Faker::Lorem.sentence(word_count: 3) }
    purchase_date { Faker::Date.backward(days: 30) }
    missing_receipt_reason { Faker::Lorem.sentence }

    trait :with_receipt do
      missing_receipt_reason { nil }
      receipt do
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'pixel.jpg'), 'image/jpeg')
      end
    end

    trait :with_pdf_receipt do
      missing_receipt_reason { nil }
      receipt do
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'receipt.pdf'), 'application/pdf')
      end
    end

    trait :approved do
      status { :approved }
      approved_by factory: %i[user]
      approved_at { Time.zone.now }
      include_in_next_collection { true }
    end

    trait :rejected do
      status { :rejected }
      rejection_reason { Faker::Lorem.sentence }
    end
  end
end
