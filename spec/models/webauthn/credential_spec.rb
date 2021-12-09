require 'rails_helper'

RSpec.describe Webauthn::Credential, type: :model do
  subject(:credential) { FactoryBot.build_stubbed(:credential) }

  describe '#valid' do
    it { expect(credential).to be_valid }

    context 'when without a user' do
      subject(:credential) { FactoryBot.build_stubbed(:credential, user: nil) }

      it { expect(credential).not_to be_valid }
    end

    context 'when without a external_id' do
      subject(:credential) { FactoryBot.build_stubbed(:credential, external_id: nil) }

      it { expect(credential).not_to be_valid }
    end

    context 'when without a public key' do
      subject(:credential) { FactoryBot.build_stubbed(:credential, public_key: nil) }

      it { expect(credential).not_to be_valid }
    end

    context 'when without a nickname' do
      subject(:credential) { FactoryBot.build_stubbed(:credential, nickname: nil) }

      it { expect(credential).not_to be_valid }
    end

    context 'when without a sign_count' do
      subject(:credential) { FactoryBot.build_stubbed(:credential, sign_count: nil) }

      it { expect(credential).not_to be_valid }
    end
  end
end
