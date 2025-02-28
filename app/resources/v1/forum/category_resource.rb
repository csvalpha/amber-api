class V1::Forum::CategoryResource < V1::ApplicationResource
  model_name 'Forum::Category'
  attributes :name, :amount_of_threads

  def amount_of_threads
    @model.threads.size
  end

  has_many :threads, always_include_linkage_data: true

  def self.records(options = {})
    options[:includes] = [:threads] if options[:context][:action] == 'index'
    super
  end

  def self.creatable_fields(_context)
    [:name]
  end

  def self.searchable_fields
    %i[name]
  end
end
