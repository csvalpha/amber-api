shared_examples 'an updatable and permissible model' do
  let(:valid_attributes) { record.attributes }
  let(:valid_relationships) { {} }
  let(:invalid_attributes) { valid_attributes }
  let(:invalid_relationships) { valid_relationships }

  let(:valid_request) do
    put(record_url,
        data: {
          id: record.id,
          type: record_type(record),
          attributes: valid_attributes,
          relationships: valid_relationships
        })
  end

  let(:invalid_request) do
    put(record_url,
        data: {
          id: record.id,
          type: record_type(record),
          attributes: invalid_attributes,
          relationships: invalid_relationships
        })
  end

  subject(:request) { valid_request }

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

      context 'when using incorrect data' do
        subject(:request) { invalid_request }

        it_behaves_like '422 Unprocessable Content'
      end
    end

    context 'when in group with permission' do
      before do
        create(:group, users: [user], permission_list: [record_permission])
      end

      it_behaves_like '200 OK'

      context 'when using incorrect data' do
        subject(:request) { invalid_request }

        it_behaves_like '422 Unprocessable Content'
      end
    end
  end
end
