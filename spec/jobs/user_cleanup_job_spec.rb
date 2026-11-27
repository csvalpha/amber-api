require 'rails_helper'

RSpec.describe UserCleanupJob do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:almost_archive_user) do
      create(:user, memberships: [
               create(:membership,
                      start_date: 20.months.ago,
                      end_date: 19.months.ago)
             ])
    end
    let(:user_to_be_archived) do
      create(:user, memberships: [
               create(:membership,
                      start_date: 22.months.ago,
                      end_date: 21.months.ago)
             ])
    end

    let(:email) { ActionMailer::Base.deliveries.first }

    before do
      ActionMailer::Base.deliveries = []
      allow(UserArchiveJob).to receive(:perform_now)

      user
      almost_archive_user
      user_to_be_archived

      perform_enqueued_jobs do
        described_class.perform_now
      end
    end

    context 'when with will archive and archived users' do
      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
      it { expect(email.to).to include Rails.application.config.x.privacy_email }
      it { expect(email.body.to_s).to include(almost_archive_user.full_name) }
      it { expect(email.body.to_s).not_to include(user.full_name) }
      it { expect(email.body.to_s).to include('Er is 1 gebruiker gearchiveerd.') }
      it { expect(UserArchiveJob).to have_received(:perform_now) }
    end

    context 'when without archive or will archive users' do
      let(:almost_archive_user) { nil }
      let(:user_to_be_archived) { nil }

      it { expect(ActionMailer::Base.deliveries.count).to eq 0 }
    end
  end

  describe '#perform when archiving a user fails' do
    let(:failing_user) do
      create(:user, memberships: [create(:membership, start_date: 23.months.ago, end_date: 22.months.ago)])
    end
    let(:other_user) do
      create(:user, memberships: [create(:membership, start_date: 22.months.ago, end_date: 21.months.ago)])
    end
    let(:email) { ActionMailer::Base.deliveries.first }

    before do
      ActionMailer::Base.deliveries = []
      allow(UserArchiveJob).to receive(:perform_now)
      allow(UserArchiveJob).to receive(:perform_now).with(failing_user.id).and_raise(ActiveRecord::InvalidForeignKey)
      allow(Sentry).to receive(:capture_exception)
      allow(HealthCheckJob).to receive(:perform_now)
      other_user

      described_class.perform_now
    end

    it { expect(UserArchiveJob).to have_received(:perform_now).with(other_user.id) }
    it { expect(Sentry).to have_received(:capture_exception).with(ActiveRecord::InvalidForeignKey, extra: { user_id: failing_user.id }) }
    it { expect(email.body.to_s).to include('Er is 1 gebruiker gearchiveerd.') }
    it { expect(HealthCheckJob).to have_received(:perform_now).with(:user_cleanup) }
  end
end
