module Debit
  class Transaction < ApplicationRecord
    belongs_to :collection
    belongs_to :user
    belongs_to :declaration, optional: true

    validates :description, presence: true
    validates :amount, presence: true
    validate :collections_not_finalized

    before_save :lock_open_collections
    before_destroy :lock_open_collections

    scope :transactions_for, ->(user) { where(user:) }

    private

    # A finalized collection matches the downloaded SEPA file, so its transactions are locked.
    # When moving a transaction, both the current and the new collection are checked.
    def collections_not_finalized
      ids = [collection_id, collection_id_in_database].compact.uniq
      return unless Debit::Collection.where(id: ids).where.not(finalized_at: nil).exists?

      errors.add(:collection, 'is al definitief gemaakt')
    end

    # The validation above gives a friendly error; this check is authoritative. It locks the transaction row
    # and reads its collection from the database (this instance may be stale), then locks that and the new
    # collection (in id order, against deadlocks) until commit, so a concurrent finalize can not slip in between.
    def lock_open_collections
      ids = [collection_id, locked_persisted_collection_id].compact.uniq
      return unless Debit::Collection.where(id: ids).order(:id).lock.pluck(:finalized_at).any?

      errors.add(:collection, 'is al definitief gemaakt')
      throw :abort
    end

    def locked_persisted_collection_id
      self.class.where(id:).lock.pick(:collection_id) if persisted?
    end
  end
end
