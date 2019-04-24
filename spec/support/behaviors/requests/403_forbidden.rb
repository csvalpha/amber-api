shared_examples '403 Forbidden' do
  it { expect(request.status).to eq(403) }
end
