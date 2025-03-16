require 'rails_helper'

describe V1::PhotoCommentsController do
  let(:user) { create(:user) }
  let(:group) { create(:group, name: 'Leden') }
  let(:membership) { create(:membership, user: user, group: group, start_date: 2.years.ago, end_date: nil) }
  let(:records) { create_list(:photo_comment, 3) }

  before do
    membership
  end

  describe 'GET /photo_comments', version: 1 do
    let(:record_url) { '/v1/photo_comments' }
    let(:record_permission) { 'photo_comment.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
  end
end
