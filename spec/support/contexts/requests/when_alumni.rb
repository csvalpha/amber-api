shared_context 'when alumni' do
  let(:user) { create(:user) }
  let(:group) { create(:group, name: 'Leden') }
  let(:membership) { create(:membership, user: user, group: group, start_date: 4.years.ago, end_date: 2.years.ago) }
  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id) }

  before do
    header('Authorization', "Bearer #{access_token.plaintext_token}")
  end
end
