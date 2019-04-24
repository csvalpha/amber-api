shared_examples 'a filterable model' do
  it { expect(records.count).to be > 2 }

  let(:filtered_request) do
    get("#{record_url}?filter[id]=#{records.first.id},#{records.second.id}")
  end

  subject(:request) { filtered_request }

  it_behaves_like '200 OK'
  it { expect(json_object_ids).to contain_exactly(records.first.id, records.second.id) }
end
