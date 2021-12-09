require 'rails_helper'

describe V1::Webauthn::Login::ChallengesController do
  describe 'POST /webauthn/login/challenges', version: 1 do
    let(:record) { FactoryBot.create(:challenge) }
    let(:record_url) { '/v1/webauthn/login/challenges' }
    let(:user) { FactoryBot.create(:user) }

    before { user }

    context 'when not authenticated' do
      subject(:request) { post(record_url, { username: user.username }) }

      it_behaves_like '200 OK'
      it { expect { request }.to(change { record.class.count }.by(1)) }
    end
  end
end
