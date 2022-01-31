require 'rails_helper'

RSpec.describe QuickpostMessage, type: :model do
  subject(:quickpost_message) { build(:quickpost_message) }

  describe '#valid?' do
    it { expect(quickpost_message.valid?).to be true }

    context 'when with an empty message' do
      subject(:quickpost_message) { build(:quickpost_message, message: '') }

      it { expect(quickpost_message.valid?).to be false }
    end

    context 'when with a too long message' do
      subject(:quickpost_message) do
        build(:quickpost_message, message: Faker::Lorem.characters(number: 501))
      end

      it { expect(quickpost_message.valid?).to be false }
    end

    context 'when without a user' do
      subject(:quickpost_message) { build(:quickpost_message, author: nil) }

      it { expect(quickpost_message.valid?).to be false }
    end
  end

  describe '#save' do
    context 'when it is new' do
      it do # rubocop:disable RSpec/ExampleLength
        allow(MessageBus).to receive(:publish)
        quickpost_message.save
        expect(MessageBus).to have_received(:publish).with(
          '/quickpost_messages', a_string_including(quickpost_message.author_id.to_s,
                                                    quickpost_message.message),
          group_ids: [0]
        )
      end
    end
  end
end
