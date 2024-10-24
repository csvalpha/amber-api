shared_examples 'a creatable model with group' do
  include_context 'when authenticated' do
    let(:user) { create(:user, user_permission_list: [record_permission]) }
  end
  let(:request) do
    post(record_url,
         data: {
           type: record_type(record),
           attributes: record.attributes,
           relationships: {
             group: { data: { id: record.group.id, type: 'groups' } }
           }
         })
  end

  context 'when not within group' do
    it_behaves_like '422 Unprocessable Entity'
  end

  context 'when in group' do
    before do
      create(:membership, user: user, group: record.group)
    end

    it_behaves_like '201 Created'
  end
end
