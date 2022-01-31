require 'rails_helper'

RSpec.describe UserCleanupJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:almost_archive_user) do
      create(:user, memberships: [
               create(:membership,
                      start_date: 19.months.ago,
                      end_date: 18.months.ago)
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

      user
      almost_archive_user
      user_to_be_archived

      perform_enqueued_jobs do
        described_class.perform_now
      end

      user.reload
      almost_archive_user&.reload
      user_to_be_archived&.reload
    end

    context 'when with will archive and archived users' do
      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
      it { expect(email.to).to include 'bestuur@csvalpha.nl' }
      it { expect(email.to).to include 'ict@csvalpha.nl' }
      it { expect(email.body.to_s).to include(almost_archive_user.full_name) }
      it { expect(email.body.to_s).not_to include(user.full_name) }
      it { expect(email.body.to_s).to include('Er is 1 gebruiker gearchiveerd.') }
      it { expect(user_to_be_archived.full_name).to include 'Gearchiveerde gebruiker' }
      it { expect(almost_archive_user.full_name).not_to include 'Gearchiveerde gebruiker' }
      it { expect(user.full_name).not_to include 'Gearchiveerde gebruiker' }
    end

    context 'when without archive or will archive users' do
      let(:almost_archive_user) { nil }
      let(:user_to_be_archived) { nil }

      it { expect(ActionMailer::Base.deliveries.count).to eq 0 }
    end
  end
end
