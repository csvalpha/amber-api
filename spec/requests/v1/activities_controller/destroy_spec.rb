require 'rails_helper'

describe V1::ActivitiesController do
  describe 'DELETE /activities/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { create(:activity) }
      let(:record_url) { "/v1/activities/#{record.id}" }
      let(:record_permission) { 'activity.destroy' }
    end
  end
end
