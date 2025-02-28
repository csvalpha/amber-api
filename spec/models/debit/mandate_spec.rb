require 'rails_helper'

RSpec.describe Debit::Mandate do
  subject(:mandate) { build_stubbed(:mandate) }

  describe '#valid' do
    it { expect(mandate).to be_valid }

    context 'when without a start date' do
      subject(:mandate) { build_stubbed(:mandate, start_date: nil) }

      it { expect(mandate).not_to be_valid }
    end

    context 'when with end date before start date' do
      subject(:mandate) do
        build_stubbed(:mandate, start_date: 1.day.ago, end_date: 2.days.ago)
      end

      it { expect(mandate).not_to be_valid }
    end

    context 'when without iban' do
      subject(:mandate) { build_stubbed(:mandate, iban: nil) }

      it { expect(mandate).not_to be_valid }
    end

    context 'when without iban holder' do
      subject(:mandate) { build_stubbed(:mandate, iban_holder: nil) }

      it { expect(mandate).not_to be_valid }
    end

    context 'when without a user' do
      subject(:mandate) { build_stubbed(:mandate, user: nil) }

      it { expect(mandate).not_to be_valid }
    end

    context 'unique_on_time_interval?' do
      let(:existing_mandate) do
        create(:mandate, start_date: 2.weeks.ago,
                         end_date: 1.week.ago)
      end

      context 'with start_time within existing range' do
        subject(:mandate) do
          build(:mandate, user: existing_mandate.user,
                          start_date: existing_mandate.end_date)
        end

        it { expect(mandate).not_to be_valid }
      end

      context 'with end_time within existing range' do
        subject(:mandate) do
          build(:mandate, user: existing_mandate.user,
                          start_date: existing_mandate.start_date - 1.day,
                          end_date: existing_mandate.start_date)
        end

        it { expect(mandate).not_to be_valid }
      end

      context 'when start_time and end_time within existing range' do
        subject(:mandate) do
          build(:mandate, user: existing_mandate.user,
                          start_date: existing_mandate.start_date + 1.day,
                          end_date: existing_mandate.end_date - 1.day)
        end

        it { expect(mandate).not_to be_valid }
      end

      context 'when start_time and end_time cover existing range' do
        subject(:mandate) do
          build(:mandate, user: existing_mandate.user,
                          start_date: existing_mandate.start_date - 1.day,
                          end_date: existing_mandate.end_date + 1.day)
        end

        it { expect(mandate).not_to be_valid }
      end

      context 'when without overlap' do
        subject(:mandate) do
          build(:mandate, user: existing_mandate.user,
                          start_date: existing_mandate.start_date - 2.days,
                          end_date: existing_mandate.start_date - 1.day)
        end

        it { expect(mandate).to be_valid }
      end
    end
  end

  describe '.active' do
    context 'when without end_date' do
      let(:mandate) { create(:mandate) }

      it { expect(described_class.active).to include mandate }
    end

    context 'when end date is in future' do
      let(:mandate) { create(:mandate, end_date: 1.day.from_now) }

      it { expect(described_class.active).to include mandate }
    end

    context 'when end date is in past' do
      let(:mandate) { create(:mandate, end_date: 1.day.ago) }

      it { expect(described_class.active).not_to include mandate }
    end
  end

  describe '.mandates_for' do
    subject(:mandate) { create(:mandate) }

    context 'when mandate is for user' do
      let(:scoped) { described_class.mandates_for(mandate.user) }

      it { expect(scoped).to contain_exactly(mandate) }
    end

    context 'when mandate is for another user' do
      let(:user) { create(:user) }
      let(:scoped) { described_class.mandates_for(user) }

      it { expect(scoped).to be_empty }
    end
  end
end
