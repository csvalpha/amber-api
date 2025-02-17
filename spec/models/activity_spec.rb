require 'rails_helper'

RSpec.describe Activity do
  subject(:activity) { build_stubbed(:activity) }

  describe '#valid' do
    it { expect(activity).to be_valid }

    context 'when without an author' do
      subject(:activity) { build_stubbed(:activity, author: nil) }

      it { expect(activity).not_to be_valid }
    end

    context 'when without a group' do
      subject(:activity) { build_stubbed(:activity, group: nil) }

      it { expect(activity).to be_valid }
    end

    context 'when without a title' do
      subject(:activity) { build_stubbed(:activity, title: nil) }

      it { expect(activity).not_to be_valid }
    end

    context 'when without a description' do
      subject(:activity) { build_stubbed(:activity, description: nil) }

      it { expect(activity).not_to be_valid }
    end

    context 'when without a form' do
      subject(:activity) { build_stubbed(:activity, form: nil) }

      it { expect(activity).to be_valid }
    end

    context 'when with a negative price' do
      subject(:activity) { build_stubbed(:activity, price: -0.01) }

      it { expect(activity).not_to be_valid }
    end

    context 'when with a too large price' do
      subject(:activity) { build_stubbed(:activity, price: 1000.01) }

      it { expect(activity).not_to be_valid }
    end

    context 'when without a place' do
      subject(:activity) { build_stubbed(:activity, location: nil) }

      it { expect(activity).not_to be_valid }
    end

    context 'when without a start time' do
      subject(:activity) { build_stubbed(:activity, start_time: nil) }

      it { expect(activity).not_to be_valid }
    end

    context 'when without a end time' do
      subject(:activity) { build_stubbed(:activity, end_time: nil) }

      it { expect(activity).not_to be_valid }
    end

    context 'when end time before start time' do
      subject(:activity) do
        build_stubbed(:activity,
                      start_time: 1.day.from_now,
                      end_time: 1.day.ago)
      end

      it { expect(activity).not_to be_valid }
    end

    context 'when start time is after end day on same day' do
      subject(:activity) do
        build_stubbed(:activity,
                      start_time: Time.zone.today.middle_of_day,
                      end_time: Time.zone.today.middle_of_day + 6.hours)
      end

      it { expect(activity).to be_valid }
    end

    context 'when without a category' do
      subject(:activity) { build_stubbed(:activity, category: nil) }

      it { expect(activity).not_to be_valid }
    end

    context 'when no responses exist' do
      subject(:activity) { create(:activity, :with_form) }

      before { activity.price = 35 }

      it { expect(activity).to be_valid }
    end

    context 'when responses exist' do
      subject(:activity) { create(:activity, :with_form) }

      before do
        create(:response, form: activity.form)
      end

      describe 'when always changable fields are changed' do
        before do
          activity.location = '42 Wallaby Way, Sidney'
          activity.start_time = 1.day.from_now
          activity.end_time = 2.days.from_now
          activity.cover_photo = 'cover_photo.jpeg'
          activity.description = 'it changed!'
          activity.group = create(:group)
          activity.category = 'vorming'
          activity.title = 'Really a new title'
          activity.publicly_visible = !activity.publicly_visible
        end

        it { expect(activity).to be_valid }
      end

      describe 'when other fields are changed' do
        before do
          activity.price = 35
        end

        it { expect(activity).not_to be_valid }
      end

      describe 'when form is removed' do
        before do
          activity.form = nil
        end

        it { expect(activity).not_to be_valid }
      end
    end

    context 'when with a duplicate form' do
      let(:other_activity) { create(:activity, :with_form) }

      subject(:activity_with_duplicate_form) do
        build(:activity, form: other_activity.form)
      end

      it { expect(activity_with_duplicate_form).not_to be_valid }
    end
  end

  describe '#humanized_category' do
    context 'when category is ChOOSE' do
      let(:record) { build_stubbed(:activity, category: 'choose') }

      it { expect(record.humanized_category).to eq 'ChOOSE' }
    end

    context 'when category is ozon' do
      let(:record) { build_stubbed(:activity, category: 'ozon') }

      it { expect(record.humanized_category).to eq 'OZON' }
    end

    context 'when category is ifes' do
      let(:record) { build_stubbed(:activity, category: 'ifes') }

      it { expect(record.humanized_category).to eq 'IFES' }
    end

    context 'when category is societeit' do
      let(:record) { build_stubbed(:activity, category: 'societeit') }

      it { expect(record.humanized_category).to eq 'Sociëteit' }
    end

    context 'when it is another category' do
      let(:record) do
        build_stubbed(:activity,
                      category: %w[algemeen sociëteit vorming dinsdagkring woensdagkring
                                   disputen kiemgroepen huizen extern curiositates].sample)
      end

      it { expect(record.humanized_category).to eq record.category.capitalize }
    end
  end

  describe '#save' do
    it_behaves_like 'a model accepting a base 64 image as', :cover_photo

    describe 'when it belongs to a form' do
      subject(:activity) { create(:activity, :with_form) }

      it { expect(activity.form.author).to eq activity.author }
      it { expect(activity.form.group).to eq activity.group }
    end
  end

  describe '.upcoming' do
    let(:current_activities) do
      create_list(:activity, 3, start_time: Faker::Time.between(from: 2.days.ago,
                                                                to: 3.days.ago),
                                end_time: Faker::Time.between(from: 1.day.from_now,
                                                              to: 2.days.from_now))
    end
    let(:future_activities) do
      create_list(:activity, 2,
                  start_time: Faker::Time.between(from: 1.day.from_now,
                                                  to: 2.days.from_now),
                  end_time: Faker::Time.between(from: 3.days.from_now,
                                                to: 4.days.from_now))
    end
    let(:passed_activities) do
      create(:activity, start_time: Faker::Time.between(from: 4.days.ago,
                                                        to: 3.days.ago),
                        end_time: Faker::Time.between(from: 2.days.ago,
                                                      to: 1.day.ago))
    end

    before do
      passed_activities
      current_activities
      future_activities
    end

    it { expect(described_class.upcoming.count).to eq(5) }
    it { expect(described_class.upcoming).to match_array((future_activities + current_activities)) }
    it { expect(described_class.upcoming).not_to include(passed_activities) }
  end

  describe '.closing' do
    let(:closed_form) { create(:expired_form) }
    let(:just_closed_form) { create(:form, respond_until: 30.seconds.ago) }
    let(:almost_closing_form) { create(:form, respond_until: 30.seconds.from_now) }
    let(:upcoming_form) { create(:form, respond_until: 1.day.from_now) }
    let(:upcoming_week_form) { create(:form, respond_until: 7.days.from_now) }
    let(:far_away_form) { create(:form, respond_until: 14.days.from_now) }

    let(:closed) { create(:activity, form: closed_form) }
    let(:just_closed) { create(:activity, form: just_closed_form) }
    let(:almost_closing) { create(:activity, form: almost_closing_form) }
    let(:upcoming) { create(:activity, form: upcoming_form) }
    let(:upcoming_week) { create(:activity, form: upcoming_week_form) }
    let(:far_away) { create(:activity, form: far_away_form) }

    before do
      closed
      just_closed
      almost_closing
      upcoming
      upcoming_week
      far_away
    end

    it { expect(described_class.closing(0)).to be_empty }
    it { expect(described_class.closing(1)).to contain_exactly(almost_closing, upcoming) }

    it do
      expect(described_class.closing(7)).to contain_exactly(almost_closing, upcoming, upcoming_week)
    end

    it {
      expect(described_class.closing).to contain_exactly(almost_closing, upcoming, upcoming_week)
    }
  end

  describe '#full_day?' do
    context 'when with full day activity' do
      subject(:activity) do
        build_stubbed(:activity, :full_day)
      end

      it { expect(activity.full_day?).to be true }
    end

    context 'when with non full day activity' do
      subject(:activity) do
        build_stubbed(:activity)
      end

      it { expect(activity.full_day?).to be false }
    end
  end

  describe '#owners' do
    context 'when user belongs to organizing group' do
      let(:user) { create(:user) }
      let(:group) { create(:group, users: [user]) }

      subject(:activity) do
        build_stubbed(:activity, group:)
      end

      it { expect(activity.owners).to include user }
    end

    context 'when user is author' do
      let(:user) { create(:user) }

      subject(:activity) do
        build_stubbed(:activity, author: user, group: nil)
      end

      it { expect(activity.owners).to include user }
    end

    context 'when without public visibility' do
      subject(:activity) { build_stubbed(:activity, publicly_visible: false) }

      it { expect(activity).not_to be_valid }
    end
  end

  describe '#to_ical' do
    context 'when with full_day activity' do
      subject(:activity) do
        build_stubbed(:activity, :full_day)
      end

      it { expect(activity.to_ical.dtend).to eq activity.end_time.to_date }
      it { expect(activity.to_ical.dtstart).to eq activity.start_time.to_date }
    end

    context 'when with non full_day activity' do
      subject(:activity) do
        build_stubbed(:activity)
      end

      it { expect(activity.to_ical.dtend).to eq activity.end_time }
      it { expect(activity.to_ical.dtstart).to eq activity.start_time }
    end
  end

  describe '#publicly_visible' do
    before do
      create(:activity, publicly_visible: true)
      create(:activity, publicly_visible: true)
      create(:activity, publicly_visible: false)
    end

    it { expect(described_class.publicly_visible.count).to be 2 }
    it { expect(described_class.count - described_class.publicly_visible.count).to be 1 }
  end

  describe '#to_csv' do
    # This tests the behaviour of the application record as well
    let(:attributes) { described_class.column_names }

    context 'when exporting a valid attribute' do
      subject(:csv) { described_class.to_csv([attributes[0].to_sym]) }

      it { expect(csv).to include attributes[0] }
    end

    context 'when exporting not-allowed field' do
      subject(:csv) { described_class.to_csv([:humanized_category]) }

      it { expect(csv).not_to include 'humanized_category' }
    end

    context 'when exporting with another valid_csv_fields' do
      subject(:csv) { described_class.to_csv([:humanized_category]) }

      before do
        allow(described_class).to receive(:valid_csv_attributes).and_return([:humanized_category])
      end

      it { expect(csv).to include 'humanized_category' }
    end
  end
end
