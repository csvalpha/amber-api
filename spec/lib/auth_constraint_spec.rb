require 'rails_helper'

RSpec.describe AuthConstraint do
  describe '.sidekiq' do
    context 'when not authenticated' do
      it { expect(described_class.sidekiq?(Struct.new(:cookie_jar).new({}))).to be false }
    end

    context 'when authenticated' do
      let(:user) { create(:user) }
      let(:access_token) { Doorkeeper::AccessToken.create(resource_owner_id: user.id) }

      let(:request) do
        Struct.new(:cookie_jar).new({
                                      'ember_simple_auth-session' => JSON.generate(
                                        'authenticated' => {
                                          'access_token' => access_token.plaintext_token
                                        }
                                      )
                                    })
      end

      it { expect(described_class.sidekiq?(request)).to be false }

      context 'when authorized' do
        let(:user) { create(:user, user_permission_list: ['sidekiq.read']) }

        it { expect(described_class.sidekiq?(request)).to be true }
      end
    end
  end
end
