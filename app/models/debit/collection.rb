module Debit
  class Collection < ApplicationRecord
    require 'csv'
    attr_accessor(:import_file)

    has_paper_trail
    belongs_to :author, class_name: 'User'
    has_many :transactions, dependent: :destroy

    validates :name, presence: true
    validates :date, presence: true

    def total_transaction_amount
      transactions.sum(:amount)
    end

    def to_sepa # rubocop:disable Metrics/MethodLength
      return unless validate_date_is_in_future

      users = transactions.includes(:user).map(&:user).flatten.uniq

      transactions_by_batch = split_transactions_by_limit(4990, users)
      sepa_files = []

      transactions_by_batch.each do |batch|
        sdd = SEPA::DirectDebit.new(
          name: 'C.S.V. Alpha',
          iban: 'NL38ABNA0610262378',
          bic: 'ABNANL2A',
          creditor_identifier: 'NL08ZZZ400748020000'
        )

        batch.each do |_user, amount, mandate|
          add_transaction(sdd, amount, mandate)
        end

        sepa_files << sdd unless errors.any?
      end

      sepa_files
    end

    private

    def split_transactions_by_limit(max_amount, users) # rubocop:disable Metrics/MethodLength
      batches = []
      current_batch = []
      current_sum = 0

      users.each do |user|
        user_amount = user_amount(user)
        user_mandate = user_mandate(user)

        next unless user_amount && user_mandate

        if current_sum + user_amount > max_amount
          batches << current_batch unless current_batch.empty?
          current_batch = []
          current_sum = 0
        end

        current_batch << [user, user_amount, user_mandate]
        current_sum += user_amount
      end

      batches << current_batch unless current_batch.empty?
      batches
    end

    def add_transaction(sdd, amount, mandate) # rubocop:disable Metrics/MethodLength
      return unless amount && mandate

      sdd.add_transaction(
        name: mandate.iban_holder,
        iban: IBANTools::IBAN.new(mandate.iban).code,
        amount:,
        mandate_id: mandate.id,
        mandate_date_of_signature: mandate.start_date,
        reference: date,
        requested_date: date,
        sequence_type: 'RCUR'
      )
    end

    def user_amount(user)
      user_amount = transactions.where(user:).sum(&:amount)
      return user_amount if user_amount.positive?
      return if user_amount.zero?

      errors.add(:sepa, "#{user.full_name} has a negative collection amount")
      false
    end

    def user_mandate(user)
      mandate = user.mandates.active.last
      return mandate if mandate
      return unless user_amount(user) # User without user_amount don't need mandate

      errors.add(:sepa, "#{user.full_name} doesn't have an active mandate.")
      false
    end

    def validate_date_is_in_future
      # SepaKing has as requirement that the requested date in a transaction should be in the future
      # Because we use the date of the collection for this
      # we should check if this requirement is met
      return true if date.to_date > Time.zone.now.to_date

      errors.add(:sepa, 'can only generate sepa files for collections in future')
      false
    end
  end
end
