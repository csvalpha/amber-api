shared_examples '422 Unprocessable Entity' do
  it { expect(request.status).to eq(422) }
  it { expect(json['errors']).not_to be_empty }
end
