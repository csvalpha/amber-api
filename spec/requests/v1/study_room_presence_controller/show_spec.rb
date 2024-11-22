require 'rails_helper'

describe V1::StudyRoomPresencesController do
  describe 'GET /study_room_presences/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:study_room_presence) }
      let(:record_url) { "/v1/study_room_presences/#{record.id}" }
      let(:record_permission) { 'study_room_presence.read' }
      let(:valid_request) { get(record_url) }
    end
  end
end
