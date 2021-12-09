require 'rails_helper'

describe V1::Webauthn::ChallengesController do
  describe 'POST /webauthn/challenges', version: 1 do
    let(:record) { FactoryBot.create(:challenge) }
    let(:record_url) { '/v1/webauthn/challenges' }

    context 'when not authenticated' do
      subject(:request) { post(record_url) }

      it_behaves_like '401 Unauthorized'
      it { expect { request }.not_to(change { record.class.count }) }
    end

    describe 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user) }
      end

      let(:user_old_record) { FactoryBot.create(:challenge, user: user) }

      subject(:request) { post(record_url) }

      before do
        user_old_record
        request
      end

      it_behaves_like '200 OK'
      # Expect that the old record is destroyed, and new record is created
      it { expect { user_old_record.reload }.to raise_error ActiveRecord::RecordNotFound }
      it { expect { request }.not_to(change { record.class.count }) }
    end
  end
end
