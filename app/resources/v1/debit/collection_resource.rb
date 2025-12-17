# frozen_string_literal: true

class V1::Debit::CollectionResource < V1::ApplicationResource
  self.model = Debit::Collection

  with_timestamps

  attribute :name, :string
  attribute :date, :date
  attribute :import_file, :string, readable: false # Write-only

  has_one :author, resource: V1::UserResource
  has_many :transactions, resource: V1::Debit::TransactionResource

  searchable_fields :name

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end

  after_commit only: [:create] do |model|
    CollectionImportJob.perform_later(model.import_file, model, Graphiti.context[:user])
  end
end
