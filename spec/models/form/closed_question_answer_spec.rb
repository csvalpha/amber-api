require 'rails_helper'

RSpec.describe Form::ClosedQuestionAnswer, type: :model do
  subject(:closed_question_answer) { FactoryBot.build(:closed_question_answer) }

  describe '#valid' do
    it { expect(closed_question_answer).to be_valid }

    context 'when without a response' do
      subject(:closed_question_answer) do
        FactoryBot.build(:closed_question_answer, response: nil)
      end

      it { expect(closed_question_answer).not_to be_valid }
    end

    context 'when without an option' do
      subject(:closed_question_answer) do
        FactoryBot.build(:closed_question_answer, option: nil)
      end

      it { expect(closed_question_answer).not_to be_valid }
    end

    context 'when radio question does not reflect field type of question' do
      before { closed_question_answer.radio_question = !closed_question_answer.radio_question }

      it { expect(closed_question_answer).not_to be_valid }
    end

    context 'when question does not belong to form' do
      let(:closed_question) { FactoryBot.create(:closed_question) }
      let(:another_form) { FactoryBot.create(:form) }

      subject(:another_closed_question_answer) do
        FactoryBot.build(:closed_question_answer, question: closed_question, form: another_form)
      end

      it { expect(another_closed_question_answer).not_to be_valid }
    end

    context 'when violating unique response and option' do
      before { closed_question_answer.save }

      let(:another_closed_question_answer) do
        FactoryBot.build(:closed_question_answer,
                         response: closed_question_answer.response,
                         option: closed_question_answer.option)
      end

      it { expect(another_closed_question_answer).not_to be_valid }
      it do
        expect { another_closed_question_answer.save(validate: false) }
          .to raise_exception ActiveRecord::RecordNotUnique
      end
    end

    context 'when violating unique radio question and option' do
      let(:radio_question) { FactoryBot.create(:radio_question, :with_options) }
      let(:closed_question_answer) do
        FactoryBot.create(:closed_question_answer, question: radio_question,
                                                   option: radio_question.options.first)
      end

      before { closed_question_answer }

      subject(:another_closed_question_answer) do
        FactoryBot.build(:closed_question_answer,
                         question: radio_question,
                         option: radio_question.options.second,
                         response: closed_question_answer.response)
      end

      it { expect(another_closed_question_answer).not_to be_valid }
      it do
        expect { another_closed_question_answer.save(validate: false) }
          .to raise_exception ActiveRecord::RecordNotUnique
      end
    end

    context 'when violating unique checkbox question and option' do
      let(:checkbox_question) { FactoryBot.create(:checkbox_question, :with_options) }
      let(:closed_question_answer) do
        FactoryBot.create(:closed_question_answer,
                          question: checkbox_question, option: checkbox_question.options.first)
      end

      before { closed_question_answer }

      subject(:another_closed_question_answer) do
        FactoryBot.build(:closed_question_answer,
                         question: checkbox_question, option: checkbox_question.options.second)
      end

      it { expect(another_closed_question_answer).to be_valid }
    end

    context 'when form is not yet opened for responses' do
      before do
        closed_question_answer.form.update(respond_from: Date.tomorrow,
                                           respond_until: 3.days.from_now)
      end

      it { expect(closed_question_answer).not_to be_valid }
    end

    context 'when form is already closed for responses' do
      before do
        closed_question_answer.form.update(respond_from: 2.days.ago, respond_until: Date.yesterday)
      end

      it { expect(closed_question_answer).not_to be_valid }
    end
  end

  describe '#destroy' do
    describe 'when form has expired' do
      subject(:closed_question_answer) do
        FactoryBot.build(:closed_question_answer, form: FactoryBot.create(:expired_form))
      end

      before { closed_question_answer.destroy }

      it { expect(closed_question_answer).not_to be_deleted }
    end
  end

  describe '#after_commit' do
    before do
      allow(closed_question_answer.response).to receive(:update_completed_status!)
      closed_question_answer.run_callbacks(:commit)
    end

    it { expect(closed_question_answer.response).to have_received(:update_completed_status!) }
  end
end
