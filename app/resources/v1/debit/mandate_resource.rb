class V1::Debit::MandateResource < V1::ApplicationResource
  attributes :start_date, :end_date, :iban, :iban_holder
  model_name 'Debit::Mandate'

  has_one :user, always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[user start_date end_date iban iban_holder]
  end

  def self.searchable_fields
    %i[iban iban_holder]
  end
end
