module Import
  class User
    extend ActiveRecord::Translation
    include SpreadsheetHelper

    attr_reader :errors, :imported_users

    def initialize(file, group)
      @count = 0
      @imported_users = []
      @errors = ActiveModel::Errors.new(self)
      @file = file
      @group = group
    end

    def save!(live_run) # rubocop:disable Metrics/MethodLength
      return unless valid?

      ::User.transaction do
        get_rows(@file).each_with_index do |row, i|
          user = row_to_user(row)
          if user.valid?
            @imported_users << user
            save_user_to_group(user, @group) if live_run && user.save
          else
            errors.add(:user, "Fout in rij #{i + 2}: #{user.errors.full_messages.join(', ')}")
          end
        end
      end
    end

    def save_user_to_group(user, group)
      return unless user && group

      Membership.create(user: user, group: group, start_date: Time.zone.now)
    end

    def valid? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      if @file.nil? || @file[:file].blank?
        errors.add(:file, 'No file uploaded')
        return false
      end

      headers = get_headers(@file)

      (REQUIRED_COLUMNS - headers).each do |missing_column_name|
        errors.add(:header, "#{missing_column_name} must be present in header")
      end

      (headers - ALLOWED_COLUMNS).each do |unpermitted_column_name|
        errors.add(:header, "#{unpermitted_column_name} is not permitted to set")
      end

      errors.size.zero?
    end

    # Method used in the translation of validation errors
    def self.lookup_ancestors
      []
    end

    REQUIRED_COLUMNS = %w[email first_name last_name address postcode city
                          picture_publication_preference ifes_data_sharing_preference
                          info_in_almanak almanak_subscription_preference
                          digtus_subscription_preference].freeze

    ALLOWED_COLUMNS = %w[first_name last_name_prefix last_name
                         login_enabled emergency_contact emergency_number
                         ifes_data_sharing_preference info_in_almanak
                         almanak_subscription_preference digtus_subscription_preference
                         email birthday address postcode city
                         phone_number food_preferences vegetarian study start_study
                         picture_publication_preference].freeze

    private

    def row_to_user(row)
      row['login_enabled'] = true unless row['login_enabled']
      row['username'] = nil unless row['username']
      ::User.new(row)
    end
  end
end
