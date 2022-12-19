require 'rails_helper'

describe V1::VacanciesController do
  describe 'GET /vacancies', version: 1 do
    let(:records) { create_list(:vacancy, 3) }
    let(:record_url) { '/v1/vacancies' }
    let(:record_permission) { 'vacancy.read' }

    before { Bullet.enable = false }

    after { Bullet.enable = true }

    subject(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
