module Debit
  class Mandate < ApplicationRecord
    has_paper_trail
    belongs_to :user

    validates :start_date, presence: true
    validates :iban, :iban_holder, presence: true
    validates_datetime :end_date, after: :start_date, allow_nil: true

    validate :unique_on_time_interval?
    validate :iban_is_valid?

    scope :active, lambda {
      where('start_date <= :now AND
               (end_date > :now OR end_date IS NULL)',
            now: Time.zone.now)
    }

    scope :mandates_for, ->(user) { where(user:) }

    private

    def unique_on_time_interval?
      return true unless Debit::Mandate.where.not(id:)
                                       .where(user_id:)
                                       .exists?([<<-SQL, { start_date: start_date, end_date: end_date }])

          CAST(:start_date AS date) BETWEEN start_date AND end_date OR
          CAST(:end_date AS date) BETWEEN start_date AND end_date OR
          start_date BETWEEN CAST(:start_date AS date) AND CAST(:end_date AS date) OR
          end_date BETWEEN CAST(:start_date AS date) AND CAST(:end_date AS date) OR
          (start_date < CAST(:start_date AS date) AND end_date IS NULL) OR
          (start_date > CAST(:start_date AS date) AND CAST(:end_date AS date) IS NULL)
                                       SQL

      errors.add(:mandate, 'is not unique on time interval')
      false
    end

    def iban_is_valid?
      errors.add(:iban, 'must be valid') unless IBANTools::IBAN.valid?(iban)
    end
  end
end
