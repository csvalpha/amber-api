require 'rails_helper'

RSpec.describe Form::OpenQuestionAnswer, type: :model do
  subject(:open_question_answer) do
    build(:open_question_answer,
          question: create(:open_question, field_type: 'text'))
  end

  describe '#valid' do
    it { expect(open_question_answer).to be_valid }

    context 'when without an answer' do
      subject(:open_question_answer) do
        build(:open_question_answer, answer: nil)
      end

      it { expect(open_question_answer).not_to be_valid }
    end

    context 'when without a response' do
      subject(:open_question_answer) do
        build(:open_question_answer, response: nil)
      end

      it { expect(open_question_answer).not_to be_valid }
    end

    context 'when without a question' do
      subject(:open_question_answer) do
        build(:open_question_answer,
              question: nil, response: create(:response))
      end

      it { expect(open_question_answer).not_to be_valid }
    end

    context 'when with a non-numerical answer to a numerical question' do
      subject(:open_question_answer) do
        build(:open_question_answer,
              question: create(:open_question_number),
              answer: 'non-numerical')
      end

      it { expect(open_question_answer).not_to be_valid }
    end

    context 'when with a numerical answer to a numerical question' do
      subject(:open_question_answer) do
        build(:open_question_answer,
              question: create(:open_question_number),
              answer: Faker::Number.number(digits: 10))
      end

      it { expect(open_question_answer).to be_valid }
    end

    context 'when question does not belong to form' do
      let(:open_question) { create(:open_question) }
      let(:another_form) { create(:form) }

      subject(:another_open_question_answer) do
        build(:open_question_answer, question: open_question, form: another_form)
      end

      it { expect(another_open_question_answer).not_to be_valid }
    end

    context 'when violating unique response and question' do
      before { open_question_answer.save }

      let(:another_open_question_answer) do
        build(:open_question_answer,
              response: open_question_answer.response,
              question: open_question_answer.question)
      end

      it { expect(another_open_question_answer).not_to be_valid }
    end

    context 'when form is not yet opened for responses' do
      before do
        open_question_answer.form.update(respond_from: Date.tomorrow,
                                         respond_until: 3.days.from_now)
      end

      it { expect(open_question_answer).not_to be_valid }
    end

    context 'when form is already closed for responses' do
      before do
        open_question_answer.form.update(respond_from: 2.days.ago, respond_until: Date.yesterday)
      end

      it { expect(open_question_answer).not_to be_valid }
    end
  end

  describe '#destroy' do
    describe 'when form has expired' do
      subject(:open_question_answer) do
        build(:open_question_answer, form: create(:expired_form))
      end

      before { open_question_answer.destroy }

      it { expect(open_question_answer).not_to be_deleted }
    end
  end

  describe '#after_commit' do
    before do
      allow(open_question_answer.response).to receive(:update_completed_status!)
      open_question_answer.run_callbacks(:commit)
    end

    it { expect(open_question_answer.response).to have_received(:update_completed_status!) }
  end
end
