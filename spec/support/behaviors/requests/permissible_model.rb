shared_examples 'a permissible model' do
  let(:request) { get(record_url) }

  context 'when not authenticated' do
    it_behaves_like '401 Unauthorized'
  end

  context 'when authenticated' do
    include_context 'when authenticated'

    it_behaves_like '403 Forbidden'

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like '200 OK'
    end

    context 'when in group with permission' do
      before do
        create(:group, users: [user], permission_list: [record_permission])
      end

      it_behaves_like '200 OK'
    end
  end
end
