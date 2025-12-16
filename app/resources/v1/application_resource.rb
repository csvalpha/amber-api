# frozen_string_literal: true

class V1::ApplicationResource < Graphiti::Resource
  include MarkdownHelper

  # Use ActiveRecord adapter
  self.adapter = Graphiti::Adapters::ActiveRecord
  self.abstract_class = true

  # Default attributes for all resources
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false

  # Search filter - override searchable_fields in child resources
  filter :search, :string do
    eq do |scope, value|
      searchable = self.class.config[:searchable_fields] || []
      return scope if searchable.empty?

      arel = scope.model.arel_table
      value.to_s.split.each do |word|
        conditions = searchable.map { |field| arel[field].lower.matches("%#{word.downcase}%") }.inject(:or)
        scope = scope.where(conditions)
      end
      scope
    end
  end

  # Class method to define searchable fields
  def self.searchable_fields(*fields)
    if fields.any?
      config[:searchable_fields] = fields
    else
      config[:searchable_fields] || []
    end
  end

  # Apply Pundit scoping on index
  def base_scope
    if context&.dig(:action) == 'index' && current_user_or_application
      Pundit.policy_scope!(current_user_or_application, self.class.model)
    else
      self.class.model.all
    end
  end

  # Authorization helpers
  def current_user
    context&.dig(:user)
  end

  def current_application
    context&.dig(:application)
  end

  def current_user_or_application
    current_user || current_application
  end

  def read_permission?
    current_user&.permission?(:read, @object)
  end

  def update_permission?
    current_user&.permission?(:update, @object)
  end

  # Class-level permission checks
  class << self
    def user_can_create_or_update?(context)
      user = context&.dig(:user)
      user&.permission?(:create, model) || user&.permission?(:update, model)
    end

    def update_permission?(context)
      context&.dig(:user)&.permission?(:update, model)
    end

    def read_permission?(context)
      context&.dig(:user)&.permission?(:read, model)
    end
  end
end
