require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'GET /photo_albums', version: 1 do
    let(:records) { create_list(:photo_album, 3) }
    let(:record_url) { '/v1/photo_albums' }
    let(:record_permission) { 'photo_album.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model' do
      include_context 'when member'
    end

    it_behaves_like 'a publicly visible index request' do
      let(:model_name) { :photo_album }

      include_context 'when member'
    end

    it_behaves_like 'a searchable model', %i[title] do
      include_context 'when member'
    end

    context 'when alumni' do
      include_context 'when alumni'

      let!(:visible_records) do
        [create(:photo_album, :public), create(:photo_album, :alumni), create(:photo_album, date: 5.years.ago)]
      end

      before { create(:photo_album, date: 1.month.ago) }

      it { expect(json_object_ids).to match_array(visible_records.map(&:id)) }
    end
  end
end
