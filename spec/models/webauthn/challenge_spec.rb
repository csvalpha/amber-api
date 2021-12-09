require 'rails_helper'

RSpec.describe Webauthn::Challenge, type: :model do
  subject(:challenge) { FactoryBot.build_stubbed(:collection) }

  describe '#valid' do
    it { expect(challenge).to be_valid }

    context 'when without a user' do
      subject(:challenge) { FactoryBot.build_stubbed(:challenge, user: nil) }

      it { expect(challenge).not_to be_valid }
    end

    context 'when without a challenge' do
      subject(:challenge) { FactoryBot.build_stubbed(:challenge, challenge: nil) }

      it { expect(challenge).not_to be_valid }
    end
  end

  describe '#expired?' do
    context 'when created recently' do
      let(:challenge) { FactoryBot.build(:challenge) }

      it { expect(challenge.expired?).to eq false }
    end

    context 'when created more than 10 minutes ago' do
      let(:challenge) { FactoryBot.build(:challenge, created_at: 11.minutes.ago) }

      it { expect(challenge.expired?).to eq true }
    end
  end
end
