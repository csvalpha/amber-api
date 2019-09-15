require 'rails_helper'

RSpec.describe UserCleanupJob, type: :job do
  describe '#perform' do
    let(:user) { FactoryBot.create(:user) }
    let(:almost_remove_user) do
      FactoryBot.create(:user, memberships: [
                          FactoryBot.create(:membership,
                                            start_date: 19.months.ago,
                                            end_date: 18.months.ago)
                        ])
    end
    let(:remove_user) do
      FactoryBot.create(:user, memberships: [
                          FactoryBot.create(:membership,
                                            start_date: 22.months.ago,
                                            end_date: 21.months.ago)
                        ])
    end

    let(:email) { ActionMailer::Base.deliveries.first }

    before do
      ActionMailer::Base.deliveries = []

      user
      almost_remove_user
      remove_user

      perform_enqueued_jobs do
        described_class.perform_now
      end

      user.reload
      almost_remove_user.reload
      remove_user.reload
    end

    it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
    it { expect(email.to).to include 'bestuur@csvalpha.nl' }
    it { expect(email.to).to include 'ict@csvalpha.nl' }
    it { expect(email.body.to_s).to include(almost_remove_user.full_name) }
    it { expect(email.body.to_s).not_to include(user.full_name) }
    it { expect(email.body.to_s).to include('Er zijn 1 gebruikers verwijderd.') }
    it { expect(remove_user.full_name).to include 'Gearchiveerde gebruiker' }
    it { expect(almost_remove_user.full_name).not_to include 'Gearchiveerde gebruiker' }
    it { expect(user.full_name).not_to include 'Gearchiveerde gebruiker' }
  end
end
