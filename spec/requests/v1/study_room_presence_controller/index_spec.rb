require 'rails_helper'

describe V1::StudyRoomPresencesController do
  describe 'GET /study_room_presences', version: 1 do
    let(:records) { create_list(:study_room_presence, 3) }
    let(:record_url) { '/v1/study_room_presences' }
    let(:record_permission) { 'study_room_presence.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
