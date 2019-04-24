shared_examples '400 Bad Request' do
  it { expect(request.status).to eq(400) }
end
