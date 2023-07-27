require 'rails_helper'

describe V1::RoomsController do
  describe 'POST /rooms/:id', version: 1 do
    let(:record) { build_stubbed(:room) }
    let(:record_url) { '/v1/rooms' }
    let(:record_permission) { 'room.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { house_name: '' } }
    end

    it_behaves_like 'a creatable model with author'
  end
end
