shared_examples '200 OK' do
  it { expect(request.status).to eq(200) }
end
