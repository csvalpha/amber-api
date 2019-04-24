require 'rails_helper'

RSpec.describe Form::OpenQuestion, type: :model do
  subject(:open_question) { FactoryBot.build_stubbed(:open_question) }

  describe '#valid' do
    it { expect(open_question).to be_valid }

    context 'when without a question' do
      subject(:open_question) { FactoryBot.build_stubbed(:open_question, question: nil) }

      it { expect(open_question).not_to be_valid }
    end

    context 'when without a field_type' do
      subject(:open_question) { FactoryBot.build_stubbed(:open_question, field_type: nil) }

      it { expect(open_question).not_to be_valid }
    end

    context 'when with incorrect field_type' do
      subject(:open_question) { FactoryBot.build_stubbed(:open_question, field_type: :radio) }

      it { expect(open_question).not_to be_valid }
    end

    context 'when without a position' do
      subject(:open_question) { FactoryBot.build_stubbed(:open_question, position: nil) }

      it { expect(open_question).not_to be_valid }
    end

    context 'when with a non-numerical position' do
      subject(:open_question) { FactoryBot.build(:open_question, position: 'not_a_number') }

      it { expect(open_question).not_to be_valid }
    end

    context 'when without required' do
      subject(:open_question) { FactoryBot.build_stubbed(:open_question, required: nil) }

      it { expect(open_question).not_to be_valid }
    end

    context 'when without a form' do
      subject(:open_question) { FactoryBot.build_stubbed(:open_question, form: nil) }

      it { expect(open_question).not_to be_valid }
    end

    context 'when no responses exist for the belonging form' do
      subject(:open_question) { FactoryBot.create(:open_question) }

      it do
        expect { open_question.update(question: '...') }.not_to(change(open_question, :valid?))
      end
    end

    context 'when responses exist for the belonging form before creation' do
      let(:response) { FactoryBot.create(:response) }

      subject(:open_question) { FactoryBot.build(:open_question, form: response.form) }

      it { expect(open_question).not_to be_valid }
    end

    context 'when responses exist for the belonging form after creation' do
      subject(:open_question) { FactoryBot.create(:open_question) }

      before { FactoryBot.create(:response, form: open_question.form) }

      it do
        expect { open_question.update(question: '...') }.to(change(open_question, :valid?)
          .from(true).to(false))
      end
    end
  end
end
