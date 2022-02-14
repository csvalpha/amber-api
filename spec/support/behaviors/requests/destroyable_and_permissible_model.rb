shared_examples 'a destroyable and permissible model' do
  subject(:request) { delete(record_url) }

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
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like '204 No Content'
      it { expect { request }.to(change { record.class.count }.by(-1)) }
    end

    context 'when in group record with permission' do
      before do
        create(:group, users: [user], permission_list: [record_permission])
      end

      it_behaves_like '204 No Content'
      it { expect { request }.to(change { record.class.count }.by(-1)) }
    end
  end
end
