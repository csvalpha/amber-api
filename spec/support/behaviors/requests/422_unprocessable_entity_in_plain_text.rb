shared_examples '422 Unprocessable Entity in Plain Text' do
  it { expect(request.status).to eq(422) }
end
