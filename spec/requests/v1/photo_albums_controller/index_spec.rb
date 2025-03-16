require 'rails_helper'

describe V1::PhotoAlbumsController do
  let(:user) { create(:user) }
  let(:group) { create(:group, name: 'Leden') }
  let(:membership) { create(:membership, user: user, group: group, start_date: 2.years.ago, end_date: nil) }
  let(:records) { create_list(:photo_album, 3) }

  before do
    membership
  end

  describe 'GET /photo_albums', version: 1 do
    let(:record_url) { '/v1/photo_albums' }
    let(:record_permission) { 'photo_album.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'

    it_behaves_like 'a publicly visible index request' do
      let(:model_name) { :photo_album }
    end

    it_behaves_like 'a searchable model', %i[title]
  end
end

