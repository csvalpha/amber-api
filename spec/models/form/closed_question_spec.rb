require 'rails_helper'

RSpec.describe Form::ClosedQuestion, type: :model do
  subject(:closed_question) { FactoryBot.build_stubbed(:closed_question) }

  describe '#valid' do
    it { expect(closed_question).to be_valid }

    context 'when without a question' do
      subject(:closed_question) { FactoryBot.build_stubbed(:closed_question, question: nil) }

      it { expect(closed_question).not_to be_valid }
    end

    context 'when without a field_type' do
      subject(:closed_question) { FactoryBot.build_stubbed(:closed_question, field_type: nil) }

      it { expect(closed_question).not_to be_valid }
    end

    context 'when with incorrect field_type' do
      subject(:closed_question) { FactoryBot.build_stubbed(:closed_question, field_type: 'text') }

      it { expect(closed_question).not_to be_valid }
    end

    context 'when without a position' do
      subject(:closed_question) { FactoryBot.build_stubbed(:closed_question, position: nil) }

      it { expect(closed_question).not_to be_valid }
    end

    context 'when with a non numerical position' do
      subject(:closed_question) { FactoryBot.build(:closed_question, position: 'not_a_number') }

      it { expect(closed_question).not_to be_valid }
    end

    context 'when without required' do
      subject(:closed_question) { FactoryBot.build_stubbed(:closed_question, required: nil) }

      it { expect(closed_question).not_to be_valid }
    end

    context 'when without a form' do
      subject(:closed_question) { FactoryBot.build_stubbed(:closed_question, form: nil) }

      it { expect(closed_question).not_to be_valid }
    end

    context 'when no responses exist for the belonging form' do
      subject(:closed_question) { FactoryBot.create(:closed_question) }

      it do
        expect { closed_question.update(question: '...') }.not_to(change(closed_question, :valid?))
      end
    end

    context 'when responses exist for the belonging form before creation' do
      let(:response) { FactoryBot.create(:response) }

      subject(:closed_question) { FactoryBot.build(:closed_question, form: response.form) }

      it { expect(closed_question).not_to be_valid }
    end

    context 'when responses exist for the belonging form after creation' do
      subject(:closed_question) { FactoryBot.create(:closed_question) }

      before { FactoryBot.create(:response, form: closed_question.form) }

      it do
        expect { closed_question.update(question: '...') }.to(change(closed_question, :valid?)
          .from(true).to(false))
      end
    end
  end

  describe '#save' do
    it_behaves_like 'a model with dependent destroy relationship' do
      let(:model) { FactoryBot.create(:closed_question) }
      let(:relation) { FactoryBot.create(:closed_question_option, question: model) }
    end
  end
end
