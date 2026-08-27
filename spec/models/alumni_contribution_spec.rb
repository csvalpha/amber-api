require 'rails_helper'

RSpec.describe AlumniContribution, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      expect(AlumniContribution.reflect_on_association(:user)).to be_a(ActiveRecord::Reflection::BelongsToReflection)
    end
  end

  describe 'validations' do
    subject(:alumni_contribution) { build(:alumni_contribution) }

    it { expect(alumni_contribution).to be_valid }

    describe 'user' do
      it 'validates presence of user' do
        alumni_contribution.user = nil
        expect(alumni_contribution).not_to be_valid
        expect(alumni_contribution.errors[:user]).to include('must exist')
      end

      it 'validates uniqueness of user' do
        existing = create(:alumni_contribution)
        alumni_contribution.user = existing.user
        expect(alumni_contribution).not_to be_valid
        expect(alumni_contribution.errors[:user]).to include('has already been taken')
      end
    end

    describe 'sponsoring_amount' do
      it 'validates numericality is greater than or equal to 0' do
        alumni_contribution.sponsoring_amount = -10.00
        expect(alumni_contribution).not_to be_valid
        expect(alumni_contribution.errors[:sponsoring_amount]).to include('must be greater than or equal to 0')
      end

      it 'allows zero' do
        alumni_contribution.sponsoring_amount = 0.00
        expect(alumni_contribution).to be_valid
      end

      it 'allows nil' do
        alumni_contribution.sponsoring_amount = nil
        expect(alumni_contribution).to be_valid
      end
    end

    describe 'help_digtus' do
      it 'validates inclusion in [true, false]' do
        alumni_contribution.help_digtus = nil
        expect(alumni_contribution).not_to be_valid
        expect(alumni_contribution.errors[:help_digtus]).to include('is not included in the list')
      end
    end

    describe 'help_kring' do
      it 'validates inclusion in [true, false]' do
        alumni_contribution.help_kring = nil
        expect(alumni_contribution).not_to be_valid
        expect(alumni_contribution.errors[:help_kring]).to include('is not included in the list')
      end
    end

    describe 'help_vereniging' do
      it 'validates inclusion in [true, false]' do
        alumni_contribution.help_vereniging = nil
        expect(alumni_contribution).not_to be_valid
        expect(alumni_contribution.errors[:help_vereniging]).to include('is not included in the list')
      end
    end

    describe 'help_anders' do
      it 'validates maximum length of 1000' do
        alumni_contribution.help_anders = 'a' * 1001
        expect(alumni_contribution).not_to be_valid
        expect(alumni_contribution.errors[:help_anders]).to include('is too long (maximum is 1000 characters)')
      end

      it 'allows exactly 1000 characters' do
        alumni_contribution.help_anders = 'a' * 1000
        expect(alumni_contribution).to be_valid
      end

      it 'allows nil' do
        alumni_contribution.help_anders = nil
        expect(alumni_contribution).to be_valid
      end
    end
  end

  describe 'database schema' do
    it 'has user_id column' do
      expect(AlumniContribution.column_names).to include('user_id')
    end

    it 'has sponsoring_amount column' do
      expect(AlumniContribution.column_names).to include('sponsoring_amount')
    end

    it 'has help_digtus column' do
      expect(AlumniContribution.column_names).to include('help_digtus')
    end

    it 'has help_kring column' do
      expect(AlumniContribution.column_names).to include('help_kring')
    end

    it 'has help_vereniging column' do
      expect(AlumniContribution.column_names).to include('help_vereniging')
    end

    it 'has help_anders column' do
      expect(AlumniContribution.column_names).to include('help_anders')
    end
  end
end
