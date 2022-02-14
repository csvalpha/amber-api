require 'rails_helper'

RSpec.describe Poll, type: :model do
  subject(:poll) { build_stubbed(:poll) }

  describe '#valid' do
    it { expect(poll).to be_valid }

    context 'when without an author' do
      subject(:poll) { build_stubbed(:poll, author: nil) }

      it { expect(poll).not_to be_valid }
    end

    context 'when without a form' do
      subject(:poll) { build_stubbed(:poll, form: nil) }

      it { expect(poll).not_to be_valid }
    end

    context 'when responses exist' do
      subject(:poll) { create(:poll) }

      before do
        create(:response, form: poll.form)
      end

      describe 'when form is removed' do
        before do
          poll.form = nil
        end

        it { expect(poll).not_to be_valid }
      end
    end

    context 'when form has multiple questions' do
      subject(:poll) { create(:poll) }

      before do
        create(:closed_question, form: poll.form)
        create(:closed_question, form: poll.form)
        poll.reload
      end

      it { expect(poll).not_to be_valid }
    end

    context 'when form has open question' do
      subject(:poll) { create(:poll) }

      before do
        create(:open_question, form: poll.form)
        poll.reload
      end

      it { expect(poll).not_to be_valid }
    end
  end
end
