shared_examples 'an updatable model with group' do
  include_context 'when authenticated' do
    let(:user) { create(:user, groups: [record.group]) }
  end
  let(:new_group) { create(:group) }

  subject(:request) do
    put(record_url,
        data: {
          id: record.id,
          type: record_type(record),
          attributes: record.attributes,
          relationships: { group: { data: { id: new_group.id, type: 'groups' } } }
        })
  end

  context 'when no new group is given' do
    subject(:request) do
      put(record_url,
          data: {
            id: record.id,
            type: record_type(record),
            attributes: record.attributes,
            relationships: {}
          })
    end

    it_behaves_like '200 OK'
  end

  context 'when the user is not member of the new group' do
    it_behaves_like '422 Unprocessable Content'

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) do
          create(:user, groups: [record.group],
                        user_permission_list: [record_permission])
        end
      end

      it_behaves_like '200 OK'
    end
  end

  context 'when the user is old member of the new group' do
    before do
      create(:membership, group: new_group, user:,
                          end_date: Faker::Time.between(from: 1.month.ago,
                                                        to: Date.yesterday))
    end

    it_behaves_like '422 Unprocessable Content'
  end

  context 'when the user is member of the new group' do
    before do
      create(:membership, user:, group: new_group)
    end

    it_behaves_like '200 OK'
  end
end
