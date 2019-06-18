require 'rails_helper'

describe V1::UsersController do
  describe 'POST /users/me/nextcloud', version: 1 do
    let(:group) { FactoryBot.create(:group)}
    let(:record) { FactoryBot.create(:user, groups: [group]) }
    let(:record_url) { '/v1/users/me/nextcloud' }

    subject(:request) { get(record_url) }

    describe 'when requesting' do
      context 'when not authenticated' do
        it_behaves_like '401 Unauthorized'
      end

      context 'when authenticated' do
        include_context 'when authenticated' do
          let(:user) { record }
        end

        it_behaves_like '200 OK'
        it { expect(json['id']).to eq user.id }
        it { expect(json['displayName']).to eq user.full_name }
        it { expect(json['email']).to eq user.email }
        it { expect(json['groups']).to eq group.id.to_s }
      end
    end
  end
end
