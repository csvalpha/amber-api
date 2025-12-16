# frozen_string_literal: true

class V1::Debit::TransactionResource < V1::ApplicationResource
  self.model = Debit::Transaction

  attribute :description, :string
  attribute :amount, :float

  has_one :collection, resource: V1::Debit::CollectionResource
  has_one :user, resource: V1::UserResource

  filter :collection, :integer

  searchable_fields :description
end
