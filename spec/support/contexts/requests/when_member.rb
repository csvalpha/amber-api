# Photo visibility depends on a 'Leden' membership (see PhotoAlbumPolicy::Scope).
# This makes the user of a surrounding authenticated context a current member, so they can see all photo albums.
shared_context 'when member' do
  before do
    if respond_to?(:user) && user
      create(:membership, user:, group: create(:group, name: 'Leden'), start_date: 1.year.ago)
    end
  end
end
