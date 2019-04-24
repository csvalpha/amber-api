shared_examples '406 Not Acceptable' do
  it { expect(request.status).to eq(406) }
end
