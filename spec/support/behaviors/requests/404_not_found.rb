shared_examples '404 Not Found' do
  it { expect(request.status).to eq(404) }
end
