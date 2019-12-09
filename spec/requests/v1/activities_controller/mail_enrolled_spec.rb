require 'rails_helper'

describe V1::ActivitiesController do
  describe 'POST /activities/:id/mail_enrolled', version: 1 do
    let(:message) { Faker::Hipster.paragraph(sentence_count: 3) }

    subject(:request) { post(record_url, data: { attributes: { message: message } }) }

    context 'when unauthenticated' do
      let(:record) { FactoryBot.create(:activity, :with_form) }
      let(:record_url) { "/v1/activities/#{record.id}/mail_enrolled" }

      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user) }
      end

      let(:record) { FactoryBot.create(:activity, :with_form) }
      let(:responses) { FactoryBot.create(:response, form: activity.form, completed: true) }
      let(:record_url) { "/v1/activities/#{record.id}/mail_enrolled" }

      it_behaves_like '403 Forbidden'

      context 'when with activity without form' do
        let(:record) { FactoryBot.create(:activity, author: user) }

        before { request }

        it_behaves_like '422 Unprocessable Entity'
        it { expect(ActivityMailerJob).not_to(have_been_enqueued) }
      end

      context 'when with activity user authored' do
        let(:record) { FactoryBot.create(:activity, :with_form, author: user) }

        before { request }

        describe 'with an empty message' do
          subject(:request) { post(record_url, data: { attributes: { message: nil } }) }

          it_behaves_like '422 Unprocessable Entity'
          it { expect(ActivityMailerJob).not_to(have_been_enqueued) }
        end

        describe 'with a message' do
          it_behaves_like '204 No Content'
          it { expect(ActivityMailerJob).to(have_been_enqueued.with(user, record, message)) }
        end
      end

      context 'when with activity in group that user belongs to' do
        let(:group) { FactoryBot.create(:group, users: [user]) }
        let(:record) { FactoryBot.create(:activity, :with_form, group: group) }
        let(:record_url) { "/v1/activities/#{record.id}/mail_enrolled" }

        before { request }

        it_behaves_like '204 No Content'
        it { expect(ActivityMailerJob).to(have_been_enqueued.with(user, record, message)) }
      end
    end
  end
end
