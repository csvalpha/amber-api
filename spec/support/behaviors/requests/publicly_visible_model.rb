shared_examples 'a publicly visible model' do
  context 'when not publicly visible' do
    subject(:request) { get(record_url) }

    context 'when not authenticated' do
      it_behaves_like '403 Forbidden'
    end

    context 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end
      it_behaves_like '200 OK'
    end
  end

  context 'when publicly visible' do
    subject(:request) { get(public_record_url) }

    context 'when not authenticated' do
      it_behaves_like '200 OK'
    end

    context 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end
      it_behaves_like '200 OK'
    end
  end
end
