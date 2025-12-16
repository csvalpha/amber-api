# frozen_string_literal: true

class V1::Forum::CategoryResource < V1::ApplicationResource
  self.model = Forum::Category

  attribute :name, :string
  attribute :amount_of_threads, :integer, writable: false do
    @object.threads.size
  end

  has_many :threads, resource: V1::Forum::ThreadResource

  def base_scope
    scope = super
    if context&.dig(:action) == 'index'
      scope = scope.includes(:threads)
    end
    scope
  end

  searchable_fields :name
end
