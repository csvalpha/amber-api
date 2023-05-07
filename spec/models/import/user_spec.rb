require 'rails_helper'

RSpec.describe Import::User, type: :model do
  let(:test_file_path) { Rails.root.join('spec', 'support', 'files', 'user_import.csv') }
  let(:test_file) { File.open(test_file_path) }
  let(:group) { create(:group) }
  let(:live_run) { true }
  let(:required_columns) { Import::User::REQUIRED_COLUMNS }

  subject(:user_import) { described_class.new({ file: test_file, extension: 'csv' }, group) }

  describe 'when database and required columns are in sync' do
    it { expect(User.column_names & required_columns).to match_array(required_columns) }
  end

  describe 'when importing users' do
    it { expect(user_import.valid?).to be true }
    it { expect { user_import.save!(live_run) }.not_to raise_error }

    context 'with a valid csv' do
      it { expect { user_import.save!(live_run) }.to(change(User, :count).by(3)) }

      context 'when importing a valid csv' do
        before { user_import.save!(live_run) }

        subject(:user) { User.find_by(first_name: 'Arthúr') }

        it { expect(user.username).to eq 'arthur.dekoningarends' }
        it { expect(user.login_enabled).to be false }
        it { expect(user.birthday).to eq Date.new(1970, 2, 2) }

        it { expect(User.find_by(first_name: 'Tësteç').username).to eq 'testec.vonbundenstauss' }
        it { expect(User.find_by(last_name_prefix: '\'t').username).to eq 'hansdavid.thoge' }
      end

      context 'when on a dry run' do
        it { expect { user_import.save!(false) }.to(change(User, :count).by(0)) }
      end
    end
  end

  describe 'when using a malformed csv' do
    let(:test_file_path) do
      Rails.root.join('spec', 'support', 'files', 'malformed_user_import.csv')
    end

    it { expect(user_import).to be_valid }

    context 'when contains errors' do
      before { user_import.valid? && user_import.save!(false) }

      it { expect(user_import.errors[:user].size).to eq 1 }

      it do
        expect(user_import.errors.full_messages.first).to eq(
          'User Fout in rij 2: First name moet opgegeven zijn'
        )
      end

      it { expect { user_import.save!(live_run) }.to(change(User, :count).by(0)) }
    end
  end

  describe 'when importing with unpermitted attributes' do
    let(:test_file_path) do
      Rails.root.join('spec', 'support', 'files', 'unpermitted_user_import.csv')
    end

    before { user_import.valid? }

    it { expect(user_import).not_to be_valid }

    it do
      expect(user_import.errors.full_messages.first).to eq(
        'Header password is not permitted to set'
      )
    end
  end
end
