shared_examples 'an indexable model' do
  context 'when with permission' do
    before { records }

    include_context 'when authenticated' do
      let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
    end

    it_behaves_like '200 OK'
    it { expect(json['data'].count).to eq records.first.class.all.count }
  end
end
