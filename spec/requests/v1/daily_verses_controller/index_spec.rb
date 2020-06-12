require 'rails_helper'

describe V1::DailyVersesController do
  describe 'GET /daily_verses', version: 1 do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }
    let(:record_url) { '/v1/daily_verses' }
    let(:request) do
      VCR.use_cassette('retrieve_daily_verse') do
        get record_url
      end
    end

    before do
      Timecop.freeze(Time.zone.today)
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    after do
      Timecop.return
    end

    context 'when without a daily verse in cache' do
      it { expect(cache.exist?('daily_verse')).to be(false) }
    end

    context 'when retrieving a daily verse' do
      before { request }

      it_behaves_like '200 OK'

      it 'caches the daily verse' do
        expect(cache.exist?('daily_verse')).to be(true)
      end

      it 'resets the cache after midnight' do
        Timecop.freeze(Time.zone.tomorrow)
        expect(cache.exist?('daily_verse')).to be(false)
      end
    end
  end
end
