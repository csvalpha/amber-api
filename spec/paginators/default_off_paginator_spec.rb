require 'rails_helper'

RSpec.describe DefaultOffPaginator, type: :resource do
  let(:params) { nil }
  let(:instance) { described_class.new(params) }

  describe '#apply' do
    context 'when its turned on' do
      let(:params) do
        ActionController::Parameters.new(size: 50, number: 1)
      end

      it do
        expect(instance).to receive(:apply).and_call_original # rubocop:disable RSpec/MessageSpies
        instance.apply(User, nil)
      end
    end
  end

  describe '#parse_pagination_params' do
    context 'when with params' do
      let(:params) do
        ActionController::Parameters.new(size: 50, number: 1)
      end

      it { expect(instance.turned_on).to be true }
    end

    context 'when without params' do
      it { expect(instance.turned_on).to be false }
    end

    context 'when turned on' do
      let(:params) do
        ActionController::Parameters.new(size: 50, number: 1)
      end

      it do
        # rubocop:disable RSpec/MessageSpies
        expect(instance).to receive(:links_page_params).and_call_original
        instance.links_page_params(record_count: 5)
        # rubocop:enable RSpec/MessageSpies
      end
    end
  end
end
