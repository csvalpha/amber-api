require 'rails_helper'

describe V1::UsersController do
  describe 'GET /users/:id/activate_webdav', version: 1 do
    let(:record) { create(:user) }
    let(:record_url) { "/v1/users/#{record.id}/activate_webdav" }

    subject(:request) { post(record_url) }

    it_behaves_like '401 Unauthorized'

    context 'when authenticated' do
      include_context 'when authenticated'
      it_behaves_like '403 Forbidden'

      context 'when requesting as user itself' do
        include_context 'when authenticated' do
          let(:user) { record }
        end

        it_behaves_like '204 No Content'
        it { expect { request && user.reload }.to(change(user, :webdav_secret_key)) }
      end
    end
  end
end
