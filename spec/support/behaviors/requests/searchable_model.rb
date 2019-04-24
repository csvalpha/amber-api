shared_examples 'a searchable model' do |filterable_fields|
  context 'when with permission' do
    include_context 'when authenticated' do
      let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
    end

    let(:filtered_request) do
      get("#{record_url}?filter[search]=searchforthisvalue")
    end
    let(:factory) { records.first.class.name.underscore.split('/').last.to_sym }

    subject(:request) { filtered_request }

    filterable_fields.each do |field|
      let(:new_records) do
        [
          FactoryBot.create(factory, field => 'searchforthisvalueandsomethingmore'),
          FactoryBot.create(factory, field => 'searchforthisvalue'),
          FactoryBot.create(factory)
        ]
      end

      before do
        records.map(&:destroy)
        new_records
      end

      it_behaves_like '200 OK'
      it { expect(json_object_ids).to contain_exactly(new_records.first.id, new_records.second.id) }
    end
  end
end
