require 'rails_helper'

describe V1::ActivitiesController do
  describe 'GET /activities/:id', version: 1 do
    subject(:request) { get(record_url) }

    let(:record) { create(:activity) }
    let(:record_url) { "/v1/activities/#{record.id}" }
    let(:public_record) { create(:activity, :public) }
    let(:public_record_url) { "/v1/activities/#{public_record.id}" }
    let(:record_permission) { 'activity.read' }

    it_behaves_like 'a publicly visible model'
  end
end
