shared_examples 'a filterable model for' do |filter_attributes = []|
  filter_attributes.each do |attr|
    it { expect(records.count).to be > 2 }

    let(:filtered_request) do
      get("#{record_url}?filter[#{attr}]=#{records.first.public_send(attr).id},"\
          "#{records.second.public_send(attr).id}")
    end

    subject(:request) { filtered_request }

    it_behaves_like '200 OK'
    it { expect(json_object_ids).to contain_exactly(records.first.id, records.second.id) }
  end
end
