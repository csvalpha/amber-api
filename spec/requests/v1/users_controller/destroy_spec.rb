require 'rails_helper'

describe V1::UsersController do
  describe 'DELETE /users/:id', version: 1 do
    let(:record) { create(:user) }
    let(:record_url) { "/v1/users/#{record.id}" }

    subject(:request) { delete(record_url) }

    it_behaves_like '404 Not Found'
  end
end
