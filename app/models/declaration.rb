class Declaration < ApplicationRecord
  STATUSES = %w[pending approved partially_paid paid rejected].freeze
  # Fields that end up on the PDF; changing one of them on an approved declaration regenerates the PDF
  CONTENT_FIELDS = %w[amount description purchase_date receipt missing_receipt_reason].freeze
  LOCKED_STATUSES = %w[partially_paid paid rejected].freeze

  has_paper_trail
  mount_base64_uploader :receipt, ReceiptUploader

  belongs_to :user
  belongs_to :approved_by, class_name: 'User', optional: true
  has_many :transactions, class_name: 'Debit::Transaction', dependent: :restrict_with_error

  enum :status, STATUSES.index_with(&:itself), validate: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true, length: { maximum: 255 }
  validates :purchase_date, presence: true
  validates_date :purchase_date, on_or_before: :today, allow_nil: true
  validates :rejection_reason, presence: true, if: :rejected?
  validate :receipt_or_missing_receipt_reason
  validate :amount_not_below_paid_amount, if: :persisted?
  validate :locked_fields_unchanged, on: :update

  scope :settleable, -> { where(status: %w[approved partially_paid], include_in_next_collection: true) }

  after_commit :enqueue_pdf_upload, on: %i[create update], if: :pdf_outdated?

  def paid_amount
    -transactions.sum(:amount)
  end

  def open_amount
    amount - paid_amount
  end

  def approve!(approver)
    unless user.mandates.active.exists?
      errors.add(:user, 'heeft geen actief incassomandaat')
      return false
    end

    update(status: :approved, approved_by: approver, approved_at: Time.zone.now, include_in_next_collection: true)
  end

  def reject!(reason)
    update(status: :rejected, rejection_reason: reason)
  end

  private

  def receipt_or_missing_receipt_reason
    if receipt.blank? && missing_receipt_reason.blank?
      errors.add(:receipt, 'of een reden waarom de bon ontbreekt is verplicht')
    elsif receipt.present? && missing_receipt_reason.present?
      errors.add(:missing_receipt_reason, 'mag niet ingevuld zijn als er een bon is')
    end
  end

  def amount_not_below_paid_amount
    return if amount.blank? || amount >= paid_amount

    errors.add(:amount, 'mag niet lager zijn dan het al uitbetaalde bedrag')
  end

  def locked_fields_unchanged
    return unless status_in_database.in?(LOCKED_STATUSES)
    return unless changed.intersect?(CONTENT_FIELDS)

    errors.add(:base, 'Deze declaratie is al afgehandeld en kan niet meer inhoudelijk worden aangepast')
  end

  def pdf_outdated?
    approved? && (saved_change_to_status? || saved_changes.keys.intersect?(CONTENT_FIELDS))
  end

  def enqueue_pdf_upload
    DeclarationPdfJob.perform_later(self)
  end
end
