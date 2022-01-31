shared_examples 'a creatable and permissible model' do |incorrect_data_response_behaves_like: '422 Unprocessable Entity'| # rubocop:disable Layout/LineLength
  let(:valid_attributes) { record.attributes }
  let(:valid_relationships) { {} }
  let(:invalid_attributes) { valid_attributes }
  let(:invalid_relationships) { valid_relationships }

  let(:valid_request) do
    post(record_url,
         data: {
           type: record_type(record),
           attributes: valid_attributes,
           relationships: valid_relationships
         })
  end

  let(:invalid_request) do
    post(record_url,
         data: {
           type: record_type(record),
           attributes: invalid_attributes,
           relationships: invalid_relationships
         })
  end

  context 'when not authenticated' do
    subject(:request) { valid_request }

    it_behaves_like '401 Unauthorized'
    it { expect { request }.not_to(change { record.class.count }) }
  end

  describe 'when authenticated' do
    include_context 'when authenticated'

    subject(:request) { valid_request }

    it_behaves_like '403 Forbidden'
    it { expect { request }.not_to(change { record.class.count }) }

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like '201 Created'
      it { expect { request }.to(change { record.class.count }.by(1)) }

      context 'when using incorrect data' do
        subject(:request) { invalid_request }

        it_behaves_like incorrect_data_response_behaves_like
        it { expect { request }.not_to(change { record.class.count }) }
      end
    end

    context 'when in group with permission' do
      before do
        create(:group, users: [user], permission_list: [record_permission])
      end

      it_behaves_like '201 Created'
      it { expect { request }.to(change { record.class.count }.by(1)) }

      context 'when using incorrect data' do
        subject(:request) { invalid_request }

        it_behaves_like incorrect_data_response_behaves_like
        it { expect { request }.not_to(change { record.class.count }) }
      end
    end
  end
end
