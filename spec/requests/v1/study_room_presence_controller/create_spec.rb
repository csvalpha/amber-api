require 'rails_helper'

describe V1::StudyRoomPresencesController do
  describe 'POST /study_room_presences/:id', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { build(:study_room_presence) }
      let(:record_url) { '/v1/study_room_presences' }
      let(:record_permission) { 'study_room_presence.create' }
      let(:invalid_attributes) { { status: '' } }
    end
  end
end
