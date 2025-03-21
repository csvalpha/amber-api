class V1::ApplicationResource < JSONAPI::Resource
  include MarkdownHelper
  include JSONAPI::Authorization::PunditScopedResource
  abstract

  attributes :created_at, :updated_at

  filter :search

  # :nocov:
  def self.creatable_fields(_context)
    []
  end
  # :nocov:

  def self.updatable_fields(context)
    creatable_fields(context)
  end

  # :nocov:
  def self.searchable_fields
    []
  end
  # :nocov:

  def self.apply_filter(records, filter, value, options)
    # Monkeypatch for weird bug in filter method
    # When defining a filter on application level
    # it will be applied before knowing which resource it is in
    # When doing it with overwriting apply_filter (as done here) it knows which resource it is
    case filter
    when :search
      search(records, value)
    else
      super
    end
  end

  def self.search(records, value)
    return records if records == []

    arel = records.first.class.arel_table
    value.each do |val|
      val.split.each do |word|
        records = records.where(
          searchable_fields.map { |field| arel[field].lower.matches("%#{word.downcase}%") }.inject(:or)
        )
      end
    end
    records
  end

  def self.records(options = {})
    is_index = options.fetch(:context, {}).fetch(:action, {}) == 'index'
    includes = options.fetch(:includes, {}) || []
    records ||= _model_class.includes(includes)
    if is_index
      records = Pundit.policy_scope!(current_user_or_application(options),
                                     _model_class).includes(includes)
    end
    records
  end

  def read_permission?
    current_user&.permission?(:read, @model)
  end

  def update_permission?
    current_user&.permission?(:update, @model)
  end

  def self.user_can_create_or_update?(context)
    context[:user]&.permission?(:create, _model_class) ||
      context[:user]&.permission?(:update, _model_class)
  end

  def current_user
    context.fetch(:user)
  end

  # :nocov:
  def current_application
    context.fetch(:application)
  end
  # :nocov:

  def self.current_user_or_application(options)
    options.fetch(:context).fetch(:user) || options.fetch(:context).fetch(:application)
  end
end
