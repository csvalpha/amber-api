shared_examples 'a model accepting a base 64 image as' do |attr|
  let(:white_pixel) do
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAA
    AAC0lEQVR42mP8/x8AAwMCAO+ip1sAAAAASUVORK5CYII='
  end
  let(:model_name) { described_class.to_s.downcase }

  subject(:model) { FactoryBot.create(described_class.to_s.downcase) }

  context 'when passing a valid image' do
    it do
      expect { model.update(attr => "data:image/jpeg;base64,#{white_pixel}") }
        .to(change { model.public_send(attr).url }
        .from(nil))
    end
  end

  context 'when passing another valid image' do
    subject(:model) do
      FactoryBot.create(model_name, attr => "data:image/jpeg;base64,#{white_pixel}")
    end

    before { model.instance_variable_set(:"@#{attr}_secure_token", nil) }

    it do
      expect { model.public_send(attr).recreate_versions! }
        .to(change { model.public_send(attr).url })
    end
  end

  context 'when passing an invalid image' do
    let(:invalid_image) { 'not_base64' }

    it do
      expect { model.update(attr => "data:image/jpeg;base64,#{invalid_image}") }
        .not_to(change { model.public_send(attr).url })
    end
  end
end
