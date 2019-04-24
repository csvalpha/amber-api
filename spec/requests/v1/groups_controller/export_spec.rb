require 'rails_helper'

describe V1::GroupsController do
  describe 'GET /groups/:id/export', version: 1 do
    let(:users) { FactoryBot.create_list(:user, 3) }
    let(:record) { FactoryBot.create(:group, users: users) }
    let(:record_url) { "/v1/groups/#{record.id}/export?description=blahblah" }
    let(:record_permission) { 'group.read' }
    let(:request) { get(record_url) }

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      it_behaves_like '403 Forbidden'

      context 'when with permission' do
        include_context 'when authenticated' do
          let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
        end

        it_behaves_like '200 OK'
        it { expect(request.body).to include 'id' }
        it { expect(request.body).to include users.last.id.to_s }

        context 'when without description' do
          let(:record_url) { "/v1/groups/#{record.id}/export" }

          it_behaves_like '422 Unprocessable Entity in Plain Text'
        end

        context 'when requesting specified fields' do
          let(:record_url) do
            "/v1/groups/#{record.id}/export?user_attrs=first_name,last_name&description=blahblah"
          end

          it_behaves_like '200 OK'
          it { expect(request.body).to include 'first_name' }
          it { expect(request.body).to include 'last_name' }
          it { expect(request.body).to include users.last.first_name }
          it { expect(request.body).to include users.last.last_name }
        end
      end
    end
  end
end
