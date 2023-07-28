require 'rails_helper'

describe V1::RoomAdvertsController do
  describe 'GET /room_adverts', version: 1 do
    let(:records) { create_list(:room_advert, 3) }
    let(:record_url) { '/v1/room_adverts' }
    let(:record_permission) { 'room_advert.read' }

    before { Bullet.enable = false }

    after { Bullet.enable = true }

    subject(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
