require 'rails_helper'

describe V1::RoomAdvertsController do
  describe 'POST /room_adverts/:id', version: 1 do
    let(:record) { build_stubbed(:room_advert) }
    let(:record_url) { '/v1/room_adverts' }
    let(:record_permission) { 'room_advert.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { house_name: '' } }
    end

    it_behaves_like 'a creatable model with author'
  end
end
