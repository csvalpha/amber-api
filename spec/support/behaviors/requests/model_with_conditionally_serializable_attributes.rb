shared_examples 'a model with conditionally serializable attributes' do
  context 'when authenticated' do
    context 'when with record permission' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like '200 OK'
      it { expect(json['data']['attributes'].keys).not_to include(*conditional_attributes) }

      context 'when also with conditional permission' do
        include_context 'when authenticated' do
          let(:user) do
            FactoryBot.create(:user,
                              user_permission_list: [record_permission, conditional_permission])
          end
        end

        it_behaves_like '200 OK'
        it { expect(json['data']['attributes'].keys).to include(*conditional_attributes) }
      end
    end

    context 'when in group with record permission' do
      include_context 'when authenticated'

      let(:group) do
        FactoryBot.create(:group, users: [user], permission_list: [record_permission])
      end

      before { group }

      it_behaves_like '200 OK'
      it { expect(json['data']['attributes'].keys).not_to include(*conditional_attributes) }

      context 'when also with conditional permission' do
        let(:group) do
          FactoryBot.create(:group, users: [user],
                                    permission_list: [record_permission, conditional_permission])
        end

        it_behaves_like '200 OK'
        it { expect(json['data']['attributes'].keys).to include(*conditional_attributes) }
      end
    end
  end
end
