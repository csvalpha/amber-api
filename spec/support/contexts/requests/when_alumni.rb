# An authenticated former member, who only sees members-only photo albums from 7.5 to 3.5 years ago
shared_context 'when alumni' do
  let(:user) { create(:user, user_permission_list: %w[photo_album.read photo.read photo_comment.read]) }
  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id) }

  before do
    create(:membership, user:, group: create(:group, name: 'Leden'), start_date: 6.years.ago, end_date: 4.years.ago)
    header('Authorization', "Bearer #{access_token.plaintext_token}")
  end
end
