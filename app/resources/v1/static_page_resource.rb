# frozen_string_literal: true

class V1::StaticPageResource < V1::ApplicationResource
  self.model = StaticPage

  with_timestamps

  # Override id attribute to accept string slugs instead of just integers
  attribute :id, :string

  attribute :title, :string
  attribute :content, :string
  attribute :content_camofied, :string, writable: false do
    camofy(@object['content'])
  end
  attribute :slug, :string, writable: false
  attribute :publicly_visible, :boolean
  attribute :category, :string

  searchable_fields :title, :content

  # Support friendly_id slugs for lookup by ID
  filter :id, :string do
    eq do |scope, value|
      # Use FriendlyId to find by slug or numeric ID
      record = scope.friendly.find(value)
      scope.where(id: record.id)
    rescue ActiveRecord::RecordNotFound
      scope.none
    end
  end

  # Support friendly_id slugs
  def base_scope
    super.friendly
  end
end
