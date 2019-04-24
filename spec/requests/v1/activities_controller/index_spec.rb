require 'rails_helper'

describe V1::ActivitiesController do
  describe 'GET /activities', version: 1 do
    let(:records) { FactoryBot.create_list(:activity, 7, :with_form) }
    let(:record_url) { '/v1/activities' }
    let(:record_permission) { 'activity.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[title description location]
    it_behaves_like 'a publicly visible index request' do
      let(:model_name) { :activity }
    end
  end
end
