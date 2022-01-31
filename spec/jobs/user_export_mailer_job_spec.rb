require 'rails_helper'

RSpec.describe UserExportMailerJob, type: :job do
  describe '#perform' do
    let(:exporting_user) { create(:user) }
    let(:group) { create(:group, users: [exporting_user]) }
    let(:fields) { %i[id first_name city] }
    let(:description) { "#{Faker::Movies::HarryPotter.quote} -- Random string with l'apostrophe" }

    let(:privacy_notification_email) { ActionMailer::Base.deliveries.first }

    before do
      ActionMailer::Base.deliveries = []

      perform_enqueued_jobs do
        described_class.perform_now(exporting_user, group, fields.join(', '), description)
      end
    end

    it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
    it { expect(privacy_notification_email.to.first).to eq 'privacy@csvalpha.nl' }
    it { expect(privacy_notification_email.body.to_s).to include(exporting_user.full_name) }
    it { expect(privacy_notification_email.body.to_s).to include(group.name) }
    it { expect(privacy_notification_email.body.to_s).to include(fields.join(', ')) }
    it { expect(privacy_notification_email.body.to_s).to include(CGI.escapeHTML(description)) }
  end
end
