require 'rails_helper'

RSpec.describe V1::PhotoResource, type: :resource do
  let(:user) { FactoryBot.create(:user) }
  let(:context) { { user: user } }
  let(:options) { { context: context } }

  describe '#amount_of_comments' do
    let(:photo) { FactoryBot.create(:photo) }
    let(:resource) { described_class.new(photo, context) }

    context 'when without comments' do
      it { expect(resource.amount_of_comments).to eq(0) }
    end

    context 'when with comments' do
      let(:photo) { FactoryBot.create(:photo) }

      before do
        FactoryBot.create(:photo_comment, photo: photo)
        FactoryBot.create(:photo_comment, photo: photo)
        FactoryBot.create(:photo_comment, photo: photo)
        photo.reload
      end

      it { expect(resource.amount_of_comments).to eq(3) }
    end
  end
end
