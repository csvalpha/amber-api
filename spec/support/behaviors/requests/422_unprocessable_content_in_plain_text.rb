shared_examples '422 Unprocessable Content in Plain Text' do
  it { expect(request.status).to eq(422) }
end
