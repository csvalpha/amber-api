require 'rails_helper'

describe V1::ActivitiesController do
  describe 'POST /activities/:id', version: 1 do
    let(:record) { create(:activity) }
    let(:record_url) { '/v1/activities' }
    let(:record_permission) { 'activity.create' }

    after { Bullet.enable = true }

    before { Bullet.enable = false }

    it_behaves_like 'a creatable model with group'

    it_behaves_like 'a creatable and permissible model' do
      let(:valid_relationships) do
        {
          author: { data: { id: record.author_id, type: 'users' } }
        }
      end
      let(:invalid_attributes) { { price: -35 } }
    end
  end
end
