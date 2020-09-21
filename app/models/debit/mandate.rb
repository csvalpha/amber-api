module Debit
  class Mandate < ApplicationRecord
    belongs_to :user

    validates :start_date, :user, presence: true
    validates :iban, :iban_holder, presence: true
    validates_datetime :end_date, after: :start_date, allow_nil: true

    validate :unique_on_time_interval?
    validate :iban_is_valid?

    scope :active, (lambda {
      where('start_date <= :now AND
               (end_date > :now OR end_date IS NULL)',
            now: Time.zone.now)
    })

    scope :mandates_for, (->(user) { where(user: user) })

    private

    def unique_on_time_interval?
      return true unless Debit::Mandate.where.not(id: id).where(user_id: user_id)
                                       .exists?([':start_date BETWEEN start_date AND end_date OR
                                        :end_date BETWEEN start_date AND end_date OR
                                        start_date BETWEEN :start_date AND :end_date OR
                                        end_date BETWEEN :start_date AND :end_date OR
                                        (start_date < :start_date AND end_date IS NULL) OR
                                        (start_date > :start_date AND :end_date IS NULL)',
                                                 { start_date: start_date, end_date: end_date }])

      errors.add(:mandate, 'is not unique on time interval')
      false
    end

    def iban_is_valid?
      errors.add(:iban, 'must be valid') unless IBANTools::IBAN.valid?(iban)
    end
  end
end
