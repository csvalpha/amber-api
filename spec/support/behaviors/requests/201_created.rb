shared_examples '201 Created' do
  it { expect(request.status).to eq(201) }
end
