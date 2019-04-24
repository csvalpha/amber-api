require 'rails_helper'

RSpec.describe Membership, type: :model do
  subject(:membership) { FactoryBot.build_stubbed(:membership) }

  describe '#valid?' do
    it { expect(membership).to be_valid }

    context 'when without a group' do
      subject(:membership) { FactoryBot.build_stubbed(:membership, group: nil) }

      it { expect(membership).not_to be_valid }
    end

    context 'when without a user' do
      subject(:membership) { FactoryBot.build_stubbed(:membership, user: nil) }

      it { expect(membership).not_to be_valid }
    end

    context 'when without a start_date' do
      subject(:membership) { FactoryBot.build_stubbed(:membership, start_date: nil) }

      it { expect(membership).not_to be_valid }
    end

    context 'unique_on_time_interval?' do
      let(:existing_membership) do
        FactoryBot.create(:membership, start_date: 2.weeks.ago,
                                       end_date: 1.week.ago)
      end

      context 'with start_time within existing range' do
        subject(:membership) do
          FactoryBot.build(:membership, user: existing_membership.user,
                                        group: existing_membership.group,
                                        start_date: existing_membership.end_date)
        end

        it { expect(membership).not_to be_valid }
      end

      context 'with end_time within existing range' do
        subject(:membership) do
          FactoryBot.build(:membership, user: existing_membership.user,
                                        group: existing_membership.group,
                                        start_date: existing_membership.start_date - 1.day,
                                        end_date: existing_membership.start_date)
        end

        it { expect(membership).not_to be_valid }
      end

      context 'when start_time and end_time within existing range' do
        subject(:membership) do
          FactoryBot.build(:membership, user: existing_membership.user,
                                        group: existing_membership.group,
                                        start_date: existing_membership.start_date + 1.day,
                                        end_date: existing_membership.end_date - 1.day)
        end

        it { expect(membership).not_to be_valid }
      end

      context 'when start_time and end_time cover existing range' do
        subject(:membership) do
          FactoryBot.build(:membership, user: existing_membership.user,
                                        group: existing_membership.group,
                                        start_date: existing_membership.start_date - 1.day,
                                        end_date: existing_membership.end_date + 1.day)
        end

        it { expect(membership).not_to be_valid }
      end

      context 'when without overlap' do
        subject(:membership) do
          FactoryBot.build(:membership, user: existing_membership.user,
                                        group: existing_membership.group,
                                        start_date: existing_membership.start_date - 2.days,
                                        end_date: existing_membership.start_date - 1.day)
        end

        it { expect(membership).to be_valid }
      end
    end

    context 'when removed membership overlaps' do
      let(:existing_membership) do
        FactoryBot.create(:membership, start_date: 2.weeks.ago,
                                       end_date: 1.week.ago)
      end

      subject(:membership) do
        FactoryBot.build(:membership, user: existing_membership.user,
                                      group: existing_membership.group,
                                      start_date: existing_membership.start_date,
                                      end_date: existing_membership.end_date)
      end

      before { existing_membership.destroy }

      it { expect(membership).to be_valid }
    end

    context 'when with membership after not ended membership' do
      let(:existing_membership) do
        FactoryBot.create(:membership, start_date: 2.weeks.ago)
      end

      subject(:membership) do
        FactoryBot.build(:membership, user: existing_membership.user,
                                      group: existing_membership.group,
                                      start_date: existing_membership.start_date + 1.day)
      end

      it { expect(membership).not_to be_valid }
    end

    context 'when with membership before not ended membership' do
      let(:existing_membership) do
        FactoryBot.create(:membership, start_date: 2.weeks.ago)
      end

      context 'when with end_date' do
        subject(:membership) do
          FactoryBot.build(:membership, user: existing_membership.user,
                                        group: existing_membership.group,
                                        start_date: existing_membership.start_date - 1.day,
                                        end_date: existing_membership.start_date + 1.day)
        end

        it { expect(membership).not_to be_valid }
      end

      context 'when without end_date' do
        subject(:membership) do
          FactoryBot.build(:membership, user: existing_membership.user,
                                        group: existing_membership.group,
                                        start_date: existing_membership.start_date - 1.day)
        end

        it { expect(membership).not_to be_valid }
      end

      context 'when ending a membership' do
        let(:existing_membership) do
          FactoryBot.create(:membership, start_date: 2.weeks.ago)
        end

        it do
          expect(existing_membership.update(end_date: Date.yesterday)).to be true
        end
      end
    end
  end
end
