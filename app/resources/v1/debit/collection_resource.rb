class V1::Debit::CollectionResource < V1::ApplicationResource
  attributes :name, :date, :import_file
  model_name 'Debit::Collection'
  model_hint model: User, resource: V1::UserResource

  has_one :author,  always_include_linkage_data: true
  has_many :transactions

  def fetchable_fields
    super - [:import_file]
  end

  def self.creatable_fields(_context)
    %i[name date import_file]
  end

  def self.searchable_fields
    %i[name]
  end

  before_create do
    @model.author_id = current_user.id
  end

  after_create do
    CollectionImportJob.perform_later(@model.import_file, @model, context[:user])
  end
end
