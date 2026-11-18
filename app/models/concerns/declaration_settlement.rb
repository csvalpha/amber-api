# Settles approved declarations on a Debit::Collection. Until the collection is finalized the
# credits are only a preview on the current collection, so it can still be deleted and re-imported.
module DeclarationSettlement
  extend ActiveSupport::Concern

  included do
    scope :not_finalized, -> { where(finalized_at: nil) }
  end

  class_methods do
    # The collection approved declarations are (provisionally) settled on:
    # the most recent one that has not been finalized yet
    def current
      not_finalized.order(date: :desc, id: :desc).first
    end
  end

  def finalized?
    finalized_at.present?
  end

  def current?
    !finalized? && self.class.current == self
  end

  # A user is credited at most the amount they owe on this collection, the rest carries over
  def pending_declaration_credits
    return [] unless current?

    budgets = transactions.where(declaration_id: nil).group(:user_id).sum(:amount)
    Declaration.settleable.order(:approved_at, :id).filter_map do |declaration|
      credit = [declaration.open_amount, budgets.fetch(declaration.user_id, 0)].min
      next unless credit.positive?

      budgets[declaration.user_id] -= credit
      { declaration:, amount: credit }
    end
  end

  # The row lock (which also reloads the record) makes a concurrent second finalize wait
  # and then see the committed finalized_at, so declarations are never settled twice
  def finalize!
    with_lock do
      if finalized?
        errors.add(:finalized_at, 'incasso is al definitief gemaakt')
        return false
      end

      settle_declarations!(pending_declaration_credits)
      raise ActiveRecord::Rollback unless sepa_valid?

      update!(finalized_at: Time.zone.now)
    end
    finalized?
  end

  private

  def settle_declarations!(credits)
    credits.each do |credit|
      declaration = credit[:declaration]
      transactions.create!(user_id: declaration.user_id, declaration:, amount: -credit[:amount],
                           description: "Declaratie: #{declaration.description}")
      declaration.transactions.reset
      declaration.update!(status: declaration.open_amount.zero? ? :paid : :partially_paid)
    end
  end

  # to_sepa adds errors and returns an empty list or nil for known problems,
  # but sepa_king raises ArgumentError on invalid transaction data (e.g. a malformed mandate)
  def sepa_valid?
    sepa_files = to_sepa
    errors.add(:sepa, 'bevat geen transacties') if sepa_files.blank? && errors.empty?
    errors.empty?
  rescue ArgumentError => e
    errors.add(:sepa, e.message)
    false
  end
end
