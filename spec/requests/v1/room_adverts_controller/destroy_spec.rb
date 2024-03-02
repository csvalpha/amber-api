require 'rails_helper'

describe V1::RoomAdvertsController do
  describe 'DELETE /room_adverts/:id', version: 1 do
    let(:record) { create(:room_advert) }
    let(:record_url) { "/v1/room_adverts/#{record.id}" }
    let(:record_permission) { 'room_advert.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
