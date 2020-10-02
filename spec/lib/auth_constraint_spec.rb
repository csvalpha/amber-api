require 'rails_helper'

RSpec.describe AuthConstraint do
  describe '.sidekiq' do
    context 'when not authenticated' do
      it { expect(described_class.sidekiq?(OpenStruct.new(cookie_jar: {}))).to be false }
    end

    context 'when authenticated' do
      let(:user) { FactoryBot.create(:user) }
      let(:access_token) { Doorkeeper::AccessToken.create(resource_owner_id: user.id) }

      let(:request) do
        OpenStruct.new(cookie_jar: {
                         'ember_simple_auth-session' => JSON.generate(
                           'authenticated' => {
                             'access_token' => access_token.plaintext_token
                           }
                         )
                       })
      end

      it { expect(described_class.sidekiq?(request)).to be false }

      context 'when authorized' do
        let(:user) { FactoryBot.create(:user, sidekiq_access: true) }

        it { expect(described_class.sidekiq?(request)).to be true }
      end
    end
  end
end
