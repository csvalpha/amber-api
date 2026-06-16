# frozen_string_literal: true

class V1::ApplicationResource < Graphiti::Resource
  include MarkdownHelper

  # Use ActiveRecord adapter
  self.adapter = Graphiti::Adapters::ActiveRecord
  self.abstract_class = true

  # Class method to add standard timestamps (call this in child resources)
  def self.with_timestamps
    attribute :created_at, :datetime, writable: false
    attribute :updated_at, :datetime, writable: false
  end

  # Class method to register searchable fields and automatically add search filter
  def self.searchable_fields(*fields)
    if fields.any?
      @searchable_fields = fields
      
      # Define the search filter for this resource
      filter :search, :string do
        eq do |scope, value|
          searchable = self.class.instance_variable_get(:@searchable_fields) || []
          next scope if searchable.empty?

          arel = scope.model.arel_table
          value.to_s.split.each do |word|
            conditions = searchable.map { |field| arel[field].lower.matches("%#{word.downcase}%") }.inject(:or)
            scope = scope.where(conditions)
          end
          scope
        end
      end
    end
    @searchable_fields || []
  end

  # Apply Pundit scoping on index
  def base_scope
    if Graphiti.context[:action] == :index && current_user_or_application
      Pundit.policy_scope!(current_user_or_application, self.class.model)
    else
      self.class.model.all
    end
  end

  # Authorization helpers
  def current_user
    Graphiti.context[:user]
  end

  def current_application
    Graphiti.context[:application]
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
    def user_can_create_or_update?
      user = Graphiti.context[:user]
      user&.permission?(:create, model) || user&.permission?(:update, model)
    end

    def update_permission?
      Graphiti.context[:user]&.permission?(:update, model)
    end

    def read_permission?
      Graphiti.context[:user]&.permission?(:read, model)
    end
  end
end
