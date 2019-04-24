require 'rails_helper'

describe V1::PollsController do
  describe 'GET /polls', version: 1 do
    let(:records) { FactoryBot.create_list(:poll, 7) }
    let(:record_url) { '/v1/polls' }
    let(:record_permission) { 'poll.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      let(:filtered_request) do
        get("#{record_url}?filter[search]=searchforthisvalue")
      end

      let(:new_records) do
        [
          FactoryBot.create(:poll),
          FactoryBot.create(:poll),
          FactoryBot.create(:poll)
        ]
      end

      subject(:request) { filtered_request }

      before do
        records.map(&:destroy)
        new_records
        FactoryBot.create(:closed_question, form: new_records.first.form)
        FactoryBot.create(:closed_question, form: new_records.second.form,
                                            question: 'searchforthisvalue')
        FactoryBot.create(:closed_question, form: new_records.last.form,
                                            question: 'searchforthisvalueandsomething')
      end

      it_behaves_like '200 OK'
      it { expect(json_object_ids).to contain_exactly(new_records.second.id, new_records.last.id) }
    end
  end
end
