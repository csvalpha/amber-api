require 'rails_helper'

RSpec.describe V1::ActivityResource, type: :resource do
  let(:user) { FactoryBot.create(:user) }
  let(:context) { { user: user } }
  let(:options) { { context: context } }

  describe 'filters' do
    let(:filtered) { described_class.apply_filters(Activity, filter, options) }

    describe 'closing' do
      let(:filter) { { closing: true } }
      let(:closing_form) { FactoryBot.create(:form, respond_until: 1.day.from_now) }
      let(:closed_form) do
        FactoryBot.create(:form, respond_until: 1.day.ago, respond_from: 2.days.ago)
      end

      before do
        FactoryBot.create(:activity, form: closed_form)
        FactoryBot.create(:activity, form: closing_form)
      end

      it { expect(filtered).to eq Activity.closing }
      it { expect(filtered.length).to eq 1 }
    end
  end
end
