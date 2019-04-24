require 'rails_helper'

describe CoffeeController do
  describe 'GET /coffee' do
    let(:record_url) { '/coffee' }
    let(:request) { get(record_url) }

    context 'when not authenticated' do
      it_behaves_like '418 IM A TEAPOT'
    end
  end
end
