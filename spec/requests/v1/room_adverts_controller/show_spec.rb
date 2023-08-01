require 'rails_helper'

describe V1::RoomAdvertsController do
  describe 'GET /room_adverts/:id', version: 1 do
    subject(:request) { get(record_url) }

    let(:record) { create(:room_advert) }
    let(:record_url) { "/v1/room_adverts/#{record.id}" }
    let(:record_permission) { 'room_advert.read' }
    let(:public_record) { create(:room_advert, :public) }
    let(:public_record_url) { "/v1/room_adverts/#{public_record.id}" }

    it_behaves_like 'a publicly visible model'
  end
end
