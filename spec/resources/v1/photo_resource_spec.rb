require 'rails_helper'

RSpec.describe V1::PhotoResource, type: :resource do
  let(:user) { create(:user) }
  let(:context) { { user: } }
  let(:options) { { context: } }

  describe '#amount_of_comments' do
    let(:photo) { create(:photo) }
    let(:resource) { described_class.new(photo, context) }

    context 'when without comments' do
      it { expect(resource.amount_of_comments).to eq(0) }
    end

    context 'when with comments' do
      let(:photo) { create(:photo) }

      before do
        create(:photo_comment, photo:)
        create(:photo_comment, photo:)
        create(:photo_comment, photo:)
        photo.reload
      end

      it { expect(resource.amount_of_comments).to eq(3) }
    end

    context 'when with tags' do
      let(:photo) { create(:photo) }

      before do
        create(:photo_tag, photo: photo)
        create(:photo_tag, photo: photo)
        create(:photo_tag, photo: photo)
        photo.reload
      end

      it { expect(resource.amount_of_tags).to eq(3) }
    end
  end
end
