require 'rails_helper'

RSpec.describe Vacancy, type: :model do
  subject(:vacancy) { build_stubbed(:vacancy) }

  describe '#valid' do
    it { expect(vacancy).to be_valid }

    context 'when without an author' do
      subject(:vacancy) { build_stubbed(:vacancy, author: nil) }

      it { expect(vacancy).not_to be_valid }
    end

    context 'when without a group' do
      subject(:vacancy) { build_stubbed(:vacancy, group: nil) }

      it { expect(vacancy).to be_valid }
    end

    context 'when without a title' do
      subject(:vacancy) { build_stubbed(:vacancy, title: nil) }

      it { expect(vacancy).not_to be_valid }
    end

    context 'when without a description' do
      subject(:vacancy) { build_stubbed(:vacancy, description: nil) }

      it { expect(vacancy).not_to be_valid }
    end
  end

  describe '#owners' do
    it_behaves_like 'a model with group owners'
  end

  describe '#save' do
    it_behaves_like 'a model accepting a base 64 image as', :cover_photo
  end
end
