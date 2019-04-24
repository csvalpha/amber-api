require 'rails_helper'

RSpec.describe ActivityMailerJob, type: :job do
  describe '#perform' do
    let(:from) { FactoryBot.create(:user) }
    let(:activity) { FactoryBot.create(:activity, :with_form) }
    let(:response) { FactoryBot.create(:response, form: activity.form, completed: true) }
    let(:message) { 'This is an example enrolled email message' }
    let(:enrolled_email) { ActionMailer::Base.deliveries.first }
    let(:deliver_report) { ActionMailer::Base.deliveries.last }

    before do
      ActionMailer::Base.deliveries = []
      response

      perform_enqueued_jobs do
        described_class.perform_now(from, activity, message)
      end
    end

    it { expect(ActionMailer::Base.deliveries.count).to eq 2 }
    it { expect(enrolled_email.to.first).to eq response.user.email }
    it { expect(enrolled_email.body.to_s).to include(message) }
    it { expect(deliver_report.to.first).to eq from.email }
    it { expect(deliver_report.body.to_s).to include(message) }
  end
end
