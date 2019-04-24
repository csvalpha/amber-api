shared_examples 'a publicly visible index request' do
  let(:public_record) { FactoryBot.create(model_name, :public) }
  let(:private_record) { FactoryBot.create(model_name) }

  let(:filtered_url) do
    "#{record_url}?filter[id]=#{public_record.id},#{private_record.id}"
  end

  subject(:request) { get(filtered_url) }

  context 'when not authenticated' do
    it_behaves_like '200 OK'

    it 'contains only filtered public models' do
      expect(json_object_ids).to contain_exactly(public_record.id)
    end
  end

  context 'when authenticated' do
    include_context 'when authenticated'
    it_behaves_like '200 OK'

    it 'contains only filtered public models' do
      expect(json_object_ids).to contain_exactly(public_record.id)
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like '200 OK'

      it 'contains both public and private filtered models' do
        expect(json_object_ids).to contain_exactly(public_record.id, private_record.id)
      end
    end
  end
end
