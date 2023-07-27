require 'rails_helper'

describe V1::RoomsController do
  describe 'DELETE /rooms/:id', version: 1 do
    let(:record) { create(:room) }
    let(:record_url) { "/v1/rooms/#{record.id}" }
    let(:record_permission) { 'room.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
