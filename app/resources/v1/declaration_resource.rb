class V1::DeclarationResource < V1::ApplicationResource
  attributes :amount, :description, :purchase_date, :receipt, :missing_receipt_reason,
             :status, :rejection_reason, :include_in_next_collection, :approved_at,
             :paid_amount, :open_amount, :has_receipt, :pdf_uploaded_at, :pdf_filename,
             :manually_paid_amount, :manually_paid_at

  has_one :user, always_include_linkage_data: true
  has_one :approved_by, class_name: 'User', always_include_linkage_data: true
  has_one :manually_paid_by, class_name: 'User', always_include_linkage_data: true
  has_many :transactions, class_name: 'Debit::Transaction'

  filter :status
  filter :user
  filter :include_in_next_collection

  # The receipt is private, it is served by DeclarationsController#receipt after authorization
  def fetchable_fields
    super - [:receipt]
  end

  delegate :paid_amount, to: :@model

  delegate :open_amount, to: :@model

  def has_receipt # rubocop:disable Naming/PredicatePrefix
    @model.receipt.present?
  end

  # The UI can not read Content-Disposition (not exposed via CORS), so it gets the name here
  def pdf_filename
    DeclarationPdf.new(@model).filename if @model.approved_at.present?
  end

  def self.creatable_fields(_context)
    %i[amount description purchase_date receipt missing_receipt_reason]
  end

  def self.updatable_fields(context)
    fields = creatable_fields(context)
    fields += %i[include_in_next_collection] if context[:user]&.permission?(:update, Declaration)
    fields
  end

  def self.searchable_fields
    %i[description]
  end

  before_create do
    @model.user_id = current_user.id
  end

  after_remove do
    unless @model.user_id == current_user.id
      DeclarationMailer.deleted_email(@model.user, @model.description, @model.amount,
                                      current_user).deliver_later
    end
  end
end
