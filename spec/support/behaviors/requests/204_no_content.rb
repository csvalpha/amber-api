shared_examples '204 No Content' do
  it { expect(request.status).to eq(204) }
end
