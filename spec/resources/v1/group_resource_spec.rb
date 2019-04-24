require 'rails_helper'

RSpec.describe V1::GroupResource, type: :resource do
  let(:user) { FactoryBot.create(:user) }
  let(:context) { { user: user } }
  let(:options) { { context: context } }

  describe '#fetchable_fields' do
    let(:basic_fields) do
      %i[id name avatar_url avatar_thumb_url created_at updated_at mail_aliases memberships users
         permissions]
    end
    let(:authenticated_fields) do
      %i[description description_camofied kind recognized_at_gma rejected_at_gma administrative]
    end
    let(:group) { FactoryBot.create(:group) }
    let(:resource) { described_class.new(group, context) }

    context 'when unauthenticated' do
      let(:user) { nil }

      it { expect(resource.fetchable_fields).to match_array(basic_fields) }
    end

    context 'when authenticated' do
      let(:fields) { basic_fields + authenticated_fields }

      it { expect(resource.fetchable_fields).to match_array(fields) }
    end
  end

  describe 'filters' do
    let(:filtered) { described_class.apply_filters(Group, filter, options) }

    describe 'kind' do
      let(:filter) { { kind: ['bestuur'] } }
      let(:group) { FactoryBot.create(:group, kind: 'bestuur') }
      let(:other_group) { FactoryBot.create(:group, kind: 'commissie') }

      before do
        group
        other_group
      end

      it { expect(filtered).to eq [group] }
      it { expect(filtered.length).to eq 1 }
    end

    describe 'administrative' do
      let(:filter) { { administrative: ['true'] } }
      let(:group) { FactoryBot.create(:group, administrative: true) }
      let(:other_group) { FactoryBot.create(:group, administrative: false) }

      before do
        group
        other_group
      end

      it { expect(filtered).to eq [group] }
      it { expect(filtered.length).to eq 1 }
    end
  end
end
