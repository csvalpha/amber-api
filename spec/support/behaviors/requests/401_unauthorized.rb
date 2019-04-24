shared_examples '401 Unauthorized' do
  it { expect(request.status).to eq(401) }
end
