require 'rails_helper'

RSpec.describe SoftDeleteCleanupJob do
  describe '#perform' do
    subject(:job) { described_class.perform_now }

    let(:record) { create(:activity) }
    let(:destroyed_record) { create(:activity, deleted_at: 1.day.ago) }
    let(:old_record) { create(:activity, deleted_at: 2.years.ago) }

    before do
      record
      destroyed_record
      old_record
    end

    it { expect { job }.not_to change(Activity, :count) }
    it { expect { job }.to change(Activity.with_deleted, :count).by(-1) }
  end
end
