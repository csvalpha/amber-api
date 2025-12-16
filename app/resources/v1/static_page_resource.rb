# frozen_string_literal: true

class V1::StaticPageResource < V1::ApplicationResource
  self.model = StaticPage

  attribute :title, :string
  attribute :content, :string
  attribute :content_camofied, :string, writable: false do
    camofy(@object['content'])
  end
  attribute :slug, :string, writable: false
  attribute :publicly_visible, :boolean
  attribute :category, :string

  searchable_fields :title, :content

  # Support friendly_id slugs
  def base_scope
    super.friendly
  end
end
