shared_examples 'a creatable model with author' do
  include_context 'when authenticated' do
    let(:user) { create(:user, user_permission_list: [record_permission]) }
  end

  let(:another_user) { create(:user) }
  let(:request) do
    post(record_url,
         data: {
           type: record_type(record),
           attributes: record.attributes,
           relationships: {
             user: { data: { id: another_user.id } }
           }
         })
  end

  context 'it sets authenticated user' do
    before { request }

    it { expect(record.class.last.author).to eq(user) }
  end
end
