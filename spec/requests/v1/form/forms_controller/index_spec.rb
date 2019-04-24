require 'rails_helper'

describe V1::Form::FormsController do
  describe 'GET /form/forms', version: 1 do
    let(:records) { FactoryBot.create_list(:form, 3) }
    let(:record_url) { '/v1/form/forms' }
    let(:record_permission) { 'form/form.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
