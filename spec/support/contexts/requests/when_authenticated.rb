shared_context 'when authenticated' do
  let(:user) { FactoryBot.create(:user) }
  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id) }

  before do
    header('Authorization', "Bearer #{access_token.token}")
  end
end
