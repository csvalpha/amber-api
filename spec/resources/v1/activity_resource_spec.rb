require 'rails_helper'

RSpec.describe V1::ActivityResource, type: :resource do
  let(:user) { create(:user) }
  let(:context) { { user: } }
  let(:options) { { context: } }

  describe 'filters' do
    let(:filtered) { described_class.apply_filters(Activity, filter, options) }

    describe 'closing' do
      let(:filter) { { closing: true } }
      let(:closing_form) { create(:form, respond_until: 1.day.from_now) }
      let(:closed_form) do
        create(:form, respond_until: 1.day.ago, respond_from: 2.days.ago)
      end

      before do
        create(:activity, form: closed_form)
        create(:activity, form: closing_form)
      end

      it { expect(filtered).to match_array Activity.closing }
      it { expect(filtered.length).to eq 1 }
    end

    describe 'group' do
      let(:group) { create(:group) }
      let(:filter) { { group: group.id } }

      before do
        create(:activity, group:)
        create(:activity)
        create(:activity)
      end

      it { expect(filtered.length).to eq 1 }
    end
  end
end
