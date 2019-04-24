shared_examples 'an updatable model with group' do
  include_context 'when authenticated' do
    let(:user) { FactoryBot.create(:user, groups: [record.group]) }
  end
  let(:new_group) { FactoryBot.create(:group) }

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
    it_behaves_like '422 Unprocessable Entity'

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) do
          FactoryBot.create(:user, groups: [record.group],
                                   user_permission_list: [record_permission])
        end
      end

      it_behaves_like '200 OK'
    end
  end

  context 'when the user is old member of the new group' do
    before do
      FactoryBot.create(:membership, group: new_group, user: user,
                                     end_date: Faker::Time.between(1.month.ago, Date.yesterday))
    end

    it_behaves_like '422 Unprocessable Entity'
  end

  context 'when the user is member of the new group' do
    before do
      FactoryBot.create(:membership, user: user, group: new_group)
    end

    it_behaves_like '200 OK'
  end
end
