require 'rails_helper'

RSpec.describe Form::ClosedQuestionOption do
  subject(:closed_question_option) { build_stubbed(:closed_question_option) }

  describe '#valid' do
    it { expect(closed_question_option.valid?).to be true }

    context 'when without a option' do
      subject(:closed_question_option) do
        build_stubbed(:closed_question_option, option: nil)
      end

      it { expect(closed_question_option.valid?).to be false }
    end

    context 'when without a position' do
      subject(:closed_question_option) do
        build_stubbed(:closed_question_option, position: nil)
      end

      it { expect(closed_question_option.valid?).to be false }
    end

    context 'when with a non numerical position' do
      subject(:closed_question_option) do
        build(:closed_question_option, position: 'not_a_number')
      end

      it { expect(closed_question_option.valid?).to be false }
    end

    context 'when without a closed question' do
      subject(:closed_question_option) do
        build_stubbed(:closed_question_option, question: nil)
      end

      it { expect(closed_question_option.valid?).to be false }
    end

    context 'when no responses exist for the belonging form' do
      subject(:closed_question_option) { create(:closed_question_option) }

      before { closed_question_option.option = '...' }

      it { expect(closed_question_option).to be_valid }
    end

    context 'when responses exist for the belonging form before creation' do
      let(:response) { create(:response) }

      subject(:closed_question_option) do
        build(:closed_question_option, form: response.form)
      end

      it { expect(closed_question_option).not_to be_valid }
    end

    context 'when responses exist for the belonging form after creation' do
      subject(:closed_question_option) { create(:closed_question_option) }

      before do
        create(:response, form: closed_question_option.form)
        closed_question_option.option = '...'
      end

      it { expect(closed_question_option).not_to be_valid }
    end
  end
end
