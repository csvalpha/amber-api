shared_examples 'a re-creatable model' do
  context 'when authenticated' do
    include_context 'when authenticated' do
      let(:user) do
        FactoryBot.create(:user, user_permission_list: [record_permission])
      end
    end

    subject(:recreate_request) do
      post(record_url,
           data: {
             id: record.id,
             type: record_type(record),
             relationships: valid_relationships
           })
    end

    it { expect(recreate_request.status).to eq(201) }
    it { expect { recreate_request }.to(change { record.class.count }.by(1)) }
    it { expect { recreate_request }.to(change { record.class.only_deleted.count }.by(-1)) }
    it { expect { recreate_request }.to(change { record.class.with_deleted.count }.by(0)) }
  end
end
