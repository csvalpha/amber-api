shared_examples '409 Conflict' do
  it { expect(request.status).to eq(409) }
end
