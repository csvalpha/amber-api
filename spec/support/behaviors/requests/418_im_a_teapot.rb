shared_examples '418 IM A TEAPOT' do
  it { expect(request.status).to eq(418) }
end
