require 'rails_helper'

RSpec.describe V1::AlumniContributionResource, type: :resource do
  let(:user) { create(:user) }
  let(:context) { { user: } }

  describe '#creatable_fields' do
    it {
      expect(described_class.creatable_fields(context)).to match_array(%i[sponsoring_amount help_digtus help_kring
                                                                          help_vereniging help_anders])
    }
  end

  describe '#updatable_fields' do
    it {
      expect(described_class.updatable_fields(context)).to match_array(%i[sponsoring_amount help_digtus help_kring
                                                                          help_vereniging help_anders])
    }
  end
end
