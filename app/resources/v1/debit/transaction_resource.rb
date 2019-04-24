class V1::Debit::TransactionResource < V1::ApplicationResource
  attributes :description, :amount
  model_name 'Debit::Transaction'

  has_one :collection
  has_one :user, always_include_linkage_data: true

  filter :collection

  def self.creatable_fields(_context)
    %i[user collection description amount]
  end

  def self.searchable_fields
    %i[description]
  end
end
