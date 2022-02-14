require 'rails_helper'

RSpec.describe Form::Form, type: :model do
  subject(:form) { build_stubbed(:form) }

  describe '#valid' do
    it { expect(form).to be_valid }

    context 'when without a publish from date' do
      subject(:form) { build_stubbed(:form, respond_from: nil) }

      it { expect(form).not_to be_valid }
    end

    context 'when without a publish until date' do
      subject(:form) { build_stubbed(:form, respond_until: nil) }

      it { expect(form).not_to be_valid }
    end

    context 'when publish until is before publish at date' do
      subject(:form) do
        build_stubbed(:form, respond_from: Date.tomorrow,
                             respond_until: Time.zone.today)
      end

      it { expect(form).not_to be_valid }
    end

    context 'when respond from is after respond until on same day' do
      subject(:form) do
        build_stubbed(:form,
                      respond_from: Time.zone.today.middle_of_day,
                      respond_until: Time.zone.today.middle_of_day + 6.hours)
      end

      it { expect(form).to be_valid }
    end
  end

  describe '#owners' do
    it_behaves_like 'a model with group owners'
  end

  describe '#destroy' do
    it_behaves_like 'a model with dependent destroy relationship', :response
    it_behaves_like 'a model with dependent destroy relationship', :open_question
    it_behaves_like 'a model with dependent destroy relationship', :closed_question
  end
end
