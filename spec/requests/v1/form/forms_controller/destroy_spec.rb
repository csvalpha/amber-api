require 'rails_helper'

describe V1::Form::FormsController do
  describe 'DELETE /form/forms/:id', version: 1 do
    let(:record) { create(:form) }
    let(:record_url) { "/v1/form/forms/#{record.id}" }
    let(:record_permission) { 'form/form.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
