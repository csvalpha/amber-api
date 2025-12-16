# frozen_string_literal: true

class V1::Debit::MandateResource < V1::ApplicationResource
  self.model = Debit::Mandate

  attribute :start_date, :date
  attribute :end_date, :date
  attribute :iban, :string
  attribute :iban_holder, :string

  has_one :user, resource: V1::UserResource

  searchable_fields :iban, :iban_holder
end
