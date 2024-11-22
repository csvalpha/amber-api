require 'rails_helper'

RSpec.describe Form::Response, type: :model do
  subject(:response) { build(:response) }

  describe '#valid' do
    it { expect(response).to be_valid }

    context 'when without an user' do
      subject(:response) { build(:response, user: nil) }

      it { expect(response).not_to be_valid }
    end

    context 'when without a form' do
      subject(:response) { build(:response, form: nil) }

      it { expect(response).not_to be_valid }
    end

    context 'when violating unique form and user' do
      before { response.save }

      let(:another_response) do
        build(:response, form: response.form, user: response.user)
      end

      it { expect(another_response).not_to be_valid }
    end

    context 'when the user is archived' do
      let(:archived_user) { create(:user, id: 0) }
      let(:another_response) do
        build(:response, form:, user: archived_user)
      end
      let(:form) { create(:form) }

      before do
        create(:response, form:, user: archived_user)
      end

      it 'allows multiple responses' do
        expect(another_response).to be_valid
      end
    end

    context 'when form is not published' do
      before do
        response.form.update(respond_from: 2.days.ago, respond_until: Date.yesterday)
      end

      subject(:response) { build(:response) }

      it { expect(response).not_to be_valid }
    end
  end

  describe '#complete' do
    it { expect(response.complete).to be true }

    describe 'with a required open question' do
      let(:open_question) do
        create(:open_question, form: response.form, required: true)
      end

      before { open_question }

      it { expect(response.complete).to be false }

      describe 'when it is answered' do
        let(:open_question_answer) do
          create(:open_question_answer, question: open_question, response:)
        end

        before do
          response.save
          open_question_answer
          response.reload
        end

        it { expect(response.complete).to be true }

        describe 'when it is unanswered again' do
          before { open_question_answer.destroy }

          it { expect(response.complete).to be false }
        end
      end
    end

    describe 'with an optional open question' do
      let(:open_question) do
        create(:open_question, form: response.form, required: false)
      end

      before { open_question }

      it { expect(response.complete).to be true }
    end

    describe 'with a required closed question' do
      let(:closed_question) do
        create(:closed_question, :with_options, form: response.form, required: true)
      end

      before { closed_question }

      it { expect(response.complete).to be false }

      describe 'when it is answered' do
        let(:closed_question_answer) do
          create(:closed_question_answer,
                 option: closed_question.options.first,
                 question: closed_question,
                 response:)
        end

        before do
          response.save
          closed_question_answer
          response.reload
        end

        it { expect(response.complete).to be true }

        describe 'when it is unanswered again' do
          before { closed_question_answer.destroy }

          it { expect(response.complete).to be false }
        end
      end
    end

    describe 'with an optional closed question' do
      let(:open_question) do
        create(:closed_question, form: response.form, required: false)
      end

      before { open_question }

      it { expect(response.complete).to be true }
    end
  end

  describe '#update_completed_status!' do
    before { response.save }

    describe 'when #complete returns true' do
      before do
        response.update(completed: false)
        allow(response).to receive(:complete).and_return(true)
      end

      it do
        expect do
          response.update_completed_status!
          response.reload
        end.to((change(response, :completed).from(false).to true))
      end
    end

    describe 'when #complete returns false' do
      before { allow(response).to receive(:complete).and_return(false) }

      it do
        expect do
          response.update_completed_status!
          response.reload
        end.to((change(response, :completed).from(true).to false))
      end
    end

    describe 'when having 2 repeating race conditions' do
      before do
        @times_called = 0
        allow(response).to receive(:complete) do
          if @times_called < 2 # rubocop:disable RSpec/InstanceVariable
            @times_called += 1
            raise ActiveRecord::StaleObjectError
          end
          true
        end
      end

      it do
        expect(response.update_completed_status!).to be true
      end
    end

    describe 'when having 3 repeating race conditions' do
      before do
        @times_called = 0
        allow(response).to receive(:complete) do
          if @times_called < 3 # rubocop:disable RSpec/InstanceVariable
            @times_called += 1
            raise ActiveRecord::StaleObjectError
          end
          true
        end
      end

      it do
        expect { response.update_completed_status! }.to raise_error(ActiveRecord::StaleObjectError)
      end
    end
  end

  describe '.completed' do
    before do
      create(:response).update(completed: true)
      create(:response).update(completed: true)
      create(:response).update(completed: false)
    end

    it { expect(described_class.completed.count).to be 2 }
    it { expect(described_class.count - described_class.completed.count).to be 1 }
  end

  describe '#destroy' do
    before { response.destroy }

    it { expect(response).to be_deleted }

    describe 'when form has expired' do
      subject(:response) do
        build(:response, form: create(:expired_form))
      end

      before { response.destroy }

      it { expect(response).not_to be_deleted }
    end
  end

  describe '#save' do
    it_behaves_like 'a model with dependent destroy relationship' do
      let(:relation) do
        create(:closed_question_answer)
      end
      let(:model) { relation.form }
    end

    it_behaves_like 'a model with dependent destroy relationship' do
      let(:relation) do
        create(:open_question_answer)
      end
      let(:model) { relation.form }
    end
  end

  describe '#after_create' do
    before do
      allow(response).to receive(:update_completed_status!)
      response.run_callbacks(:create)
    end

    it { expect(response).to have_received(:update_completed_status!) }
  end
end
