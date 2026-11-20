class V1::StaticPageResource < V1::ApplicationResource
  attributes :title, :content, :content_camofied, :slug, :publicly_visible, :category

  def content_camofied
    camofy(@model['content'])
  end

  def self.creatable_fields(_context)
    %i[title content publicly_visible category]
  end

  # Allow UUID and slugs as IDs
  def self.verify_key(key, _context = nil)
    key && String(key)
  end

  def self.find_by_key(key, options = {})
    begin
      record = records(options).friendly.find(key)
    rescue ActiveRecord::RecordNotFound
      raise JSONAPI::Exceptions::RecordNotFound.new(key) # rubocop:disable Style/RaiseArgs
    end
    self.new(record, options[:context]) # rubocop:disable Style/RedundantSelf
  end

  def self.searchable_fields
    %i[title content]
  end
end
