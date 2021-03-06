require 'rails_helper'

describe V1::UsersController do
  describe 'POST /users/:id/archive', version: 1 do
    let(:record_permission) { 'user.destroy' }
    let(:record) { FactoryBot.create(:user) }
    let(:record_url) { "/v1/users/#{record.id}/archive" }

    subject(:request) { post(record_url) }

    describe 'when archiving user' do
      context 'when not authenticated' do
        it_behaves_like '401 Unauthorized'
        it { expect { request }.not_to(change { record.class.count }) }
      end

      context 'when authenticated' do
        include_context 'when authenticated'

        it_behaves_like '403 Forbidden'
        it { expect { request }.not_to(change { record.class.count }) }

        context 'when with permission' do
          include_context 'when authenticated' do
            let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
          end

          it_behaves_like '204 No Content'
          it { expect { request }.not_to(change { record.class.count }) }
          it { expect { request }.to(change { record.reload.archived_at }) }
        end

        context 'when in group record with permission' do
          before do
            FactoryBot.create(:group, users: [user], permission_list: [record_permission])
          end

          it_behaves_like '204 No Content'
          it { expect { request }.not_to(change { record.class.count }) }
          it { expect { request }.to(change { record.reload.archived_at }) }
        end
      end

      describe 'when user archives itself' do
        let(:record) { FactoryBot.create(:user, user_permission_list: [record_permission]) }

        include_context 'when authenticated' do
          let(:user) { record }
        end

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
