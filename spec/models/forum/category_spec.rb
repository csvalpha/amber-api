require 'rails_helper'

RSpec.describe Forum::Category, type: :model do
  subject(:category) { build_stubbed(:category) }

  describe '#valid' do
    it { expect(category.valid?).to be true }

    context 'when without a name' do
      subject(:category) { build_stubbed(:category, name: nil) }

      it { expect(category.valid?).to be false }
    end
  end

  describe '#destroy' do
    it_behaves_like 'a model with dependent destroy relationship', :thread
  end
end
