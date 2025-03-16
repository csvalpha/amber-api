require 'rails_helper'

describe V1::PhotoCommentsController do
  let(:user) { create(:user) }
  let(:group) { create(:group, name: 'Leden') }
  let(:membership) { create(:membership, user: user, group: group, start_date: 2.years.ago, end_date: 1.year.from_now) }
  let(:record) { create(:photo_comment) }

  before do
    membership
  end

  describe 'GET /photo_comments/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record_url) { "/v1/photo_comments/#{record.id}" }
      let(:record_permission) { 'photo_comment.read' }
    end
  end
end