shared_examples '207 Multistatus' do
  it { expect(request.status).to eq(207) }
end
