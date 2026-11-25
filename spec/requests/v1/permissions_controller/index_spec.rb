require 'rails_helper'

describe V1::PermissionsController do
  describe 'GET /permissions', version: 1 do
    let(:records) do
      [{ name: 'activity.read' }, { name: 'article.update' }, { name: 'group.create' }].map do |p|
        create(:permission, p)
      end
    end
    let(:record_url) { '/v1/permissions' }
    let(:record_permission) { 'permission.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
