module Debit
  class Transaction < ApplicationRecord
    belongs_to :collection
    belongs_to :user
    belongs_to :declaration, optional: true

    validates :description, presence: true
    validates :amount, presence: true
    validate :collections_not_finalized

    before_destroy :prevent_destroy_on_finalized_collection

    scope :transactions_for, ->(user) { where(user:) }

    private

    # A finalized collection matches the downloaded SEPA file, so its transactions are locked.
    # When moving a transaction, both the current and the new collection are checked.
    def collections_not_finalized
      ids = [collection_id, collection_id_in_database].compact.uniq
      return unless Debit::Collection.where(id: ids).where.not(finalized_at: nil).exists?

      errors.add(:collection, 'is al definitief gemaakt')
    end

    def prevent_destroy_on_finalized_collection
      return unless collection&.finalized?

      errors.add(:collection, 'is al definitief gemaakt')
      throw :abort
    end
  end
end
