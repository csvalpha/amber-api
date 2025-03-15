FactoryBot.define do
  factory :photo do
    original_filename { "#{Faker::Lorem.word}.jpg" }
    image do
      Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'pixel.jpg'),
                                   'image/jpeg')
    end

    photo_album
    uploader factory: %i[user]

    trait(:alumni) { photo_album factory: %i[photo_album alumni] }
    trait(:invalid) do
      image do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'support', 'files', 'photo_invalid.jpg'),
          'image/jpeg'
        )
      end
    end

    trait(:png) do
      image do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'support', 'files', 'pixel.png'),
          'image/png'
        )
      end
    end
  end
end
