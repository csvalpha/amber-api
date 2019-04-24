require 'rails_helper'

describe V1::UsersController do
  describe 'DELETE /users/:id', version: 1 do
    let(:record) { FactoryBot.create(:user) }
    let(:record_url) { "/v1/users/#{record.id}" }

    subject(:request) { delete(record_url) }

    it { expect { request }.to raise_error(ActionController::RoutingError) }
  end
end
