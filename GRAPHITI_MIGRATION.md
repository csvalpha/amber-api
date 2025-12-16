# JSONAPI::Resources → Graphiti Migration Guide

This document describes all changes made to migrate from `jsonapi-resources` to `graphiti`.

## Table of Contents
- [Why Graphiti?](#why-graphiti)
- [Gemfile Changes](#gemfile-changes)
- [Configuration Changes](#configuration-changes)
- [Resource Changes](#resource-changes)
- [Controller Changes](#controller-changes)
- [Route Changes](#route-changes)
- [Frontend Changes Required](#frontend-changes-required)
- [Filter System](#filter-system)
- [Testing](#testing)

---

## Why Graphiti?

| Feature | JSONAPI::Resources | Graphiti |
|---------|-------------------|----------|
| Maintained | ❌ No longer maintained | ✅ Actively maintained |
| Rack 3.x support | ❌ | ✅ |
| JSON:API compliant | ✅ | ✅ |
| Pundit support | Via separate gem | ✅ Built-in |
| Similar DSL | - | ✅ Easy migration |

---

## Gemfile Changes

### Removed
```ruby
gem 'jsonapi-authorization', '~> 3.0', '>= 3.0.2'
gem 'jsonapi-resources', '~> 0.9.1'
```

### Added
```ruby
gem 'graphiti', '~> 1.7'
gem 'graphiti-rails', '~> 0.4'
gem 'kaminari', '~> 1.2'  # Pagination for Graphiti
```

### Installation
```bash
bundle install
```

---

## Configuration Changes

### Removed
- `config/initializers/jsonapi_resources.rb`

### Added
- `config/initializers/graphiti.rb`

```ruby
# config/initializers/graphiti.rb
Graphiti.configure do |config|
  config.pagination_links = true
end

Graphiti::Errors::InvalidRequest
Graphiti::Serializer.config do |config|
  config.default_key_transform = :underscore
end

Rails.application.config.after_initialize do
  Rails.application.eager_load! if Rails.env.development?
end
```

---

## Resource Changes

### Base Resource Class

**Before (JSONAPI::Resources):**
```ruby
class V1::ApplicationResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource
  abstract
  
  attributes :created_at, :updated_at
  
  def self.creatable_fields(_context)
    []
  end
  
  def self.records(options = {})
    # ...
  end
end
```

**After (Graphiti):**
```ruby
class V1::ApplicationResource < Graphiti::Resource
  self.adapter = Graphiti::Adapters::ActiveRecord
  self.abstract_class = true
  
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
  
  def base_scope
    if context&.dig(:action) == 'index' && current_user_or_application
      Pundit.policy_scope!(current_user_or_application, self.class.model)
    else
      self.class.model.all
    end
  end
end
```

### Key Differences

| Feature | JSONAPI::Resources | Graphiti |
|---------|-------------------|----------|
| Attributes | `attributes :name, :email` | `attribute :name, :string` (typed) |
| Model reference | `@model` | `@object` |
| Computed attributes | Method with same name | Block in attribute definition |
| Field visibility | `fetchable_fields` method | `readable` guard on attribute |
| Write permissions | `creatable_fields(context)` | `writable` guard on attribute |
| Abstract class | `abstract` | `self.abstract_class = true` |
| Model class | Auto-inferred | `self.model = User` |

### Attribute Syntax

**Before:**
```ruby
attributes :name, :email, :avatar_url

def avatar_url
  @model.avatar.url
end

def fetchable_fields
  fields = super
  fields -= [:email] unless can_read_email?
  fields
end

def self.creatable_fields(context)
  %i[name email]
end
```

**After:**
```ruby
attribute :name, :string
attribute :email, :string do
  readable { can_read_email? }
end
attribute :avatar_url, :string, writable: false do
  @object.avatar.url
end
```

### Relationship Syntax

**Before:**
```ruby
has_many :groups
has_one :author, always_include_linkage_data: true
```

**After:**
```ruby
has_many :groups
has_one :author, resource: V1::UserResource
```

### Callbacks

**Before:**
```ruby
before_create do
  @model.author_id = current_user.id
end

after_create do
  UserMailer.welcome(@model).deliver_later
end
```

**After:**
```ruby
before_save only: [:create] do |model|
  model.author_id = current_user.id
end

after_commit only: [:create] do |model|
  UserMailer.welcome(model).deliver_later
end
```

---

## Controller Changes

### Base Controller

**Before:**
```ruby
class ApplicationController < JSONAPI::ResourceController
  include Pundit::Authorization
  
  def verify_content_type_header
    true
  end
end
```

**After:**
```ruby
class ApplicationController < ActionController::API
  include Pundit::Authorization
  include Graphiti::Rails
  include Graphiti::Responders

  register_exception Graphiti::Errors::RecordNotFound, status: 404
  register_exception Graphiti::Errors::InvalidRequest, status: 400
end
```

### Resource Controllers

A new concern `GraphitiCrud` was created to provide standard CRUD operations:

```ruby
# app/controllers/concerns/graphiti_crud.rb
module GraphitiCrud
  extend ActiveSupport::Concern

  included do
    class_attribute :resource_class
  end

  class_methods do
    def graphiti_resource(klass)
      self.resource_class = klass
    end
  end

  def index
    resources = resource_class.all(params, context)
    render jsonapi: resources
  end

  def show
    resource = resource_class.find(params, context)
    render jsonapi: resource
  end

  def create
    resource = resource_class.build(params, context)
    if resource.save
      render jsonapi: resource, status: :created
    else
      render jsonapi_errors: resource
    end
  end

  def update
    resource = resource_class.find(params, context)
    if resource.update_attributes
      render jsonapi: resource
    else
      render jsonapi_errors: resource
    end
  end

  def destroy
    resource = resource_class.find(params, context)
    if resource.destroy
      head :no_content
    else
      render jsonapi_errors: resource
    end
  end
end
```

**Controller usage:**
```ruby
class V1::UsersController < V1::ApplicationController
  include GraphitiCrud
  
  graphiti_resource V1::UserResource
  
  # Custom actions still work normally
  def custom_action
    # ...
  end
end
```

---

## Route Changes

**Before:**
```ruby
namespace :v1 do
  jsonapi_resources :users do
    jsonapi_relationships
    member do
      post :activate
    end
  end
end
```

**After:**
```ruby
namespace :v1 do
  resources :users do
    member do
      post :activate
    end
  end
end
```

---

## Frontend Changes Required

### ✅ No Changes Needed

These JSON:API standard patterns work identically:

```javascript
// Filtering
GET /v1/users?filter[search]=john

// Including relationships
GET /v1/users?include=groups,memberships

// Sparse fieldsets
GET /v1/users?fields[users]=first_name,last_name

// Sorting
GET /v1/users?sort=-created_at,first_name

// Pagination
GET /v1/users?page[number]=2&page[size]=25
```

### ⚠️ Changes Required

#### 1. Pagination Response Format

**Before (JSONAPI::Resources):**
```json
{
  "data": [...],
  "meta": {
    "page_count": 5
  }
}
```

**After (Graphiti):**
```json
{
  "data": [...],
  "meta": {
    "page": {
      "current_page": 1,
      "per_page": 25,
      "total_pages": 5,
      "total_count": 125
    }
  }
}
```

**Frontend fix:**
```javascript
// Before
const totalPages = response.meta.page_count;

// After
const totalPages = response.meta.page.total_pages;
const totalRecords = response.meta.page.total_count;
```

#### 2. Boolean Filters

**Before:** Any truthy value worked
```javascript
?filter[upcoming]=1
?filter[upcoming]=yes
```

**After:** Use actual boolean values
```javascript
?filter[upcoming]=true
?filter[upcoming]=false
```

#### 3. Error Response Format

Both follow JSON:API spec, but Graphiti provides more metadata:

```json
{
  "errors": [{
    "code": "unprocessable_entity",
    "status": "422",
    "title": "Validation Error",
    "detail": "Name can't be blank",
    "meta": {
      "attribute": "name",
      "message": "can't be blank"
    }
  }]
}
```

---

## Filter System

### Basic Filter Syntax

**Before:**
```ruby
filter :upcoming, apply: ->(records, _value, _options) { records.upcoming }

filter :group, apply: lambda { |records, value, _options|
  records.where(group_id: value)
}
```

**After:**
```ruby
filter :upcoming, :boolean do
  eq do |scope, value|
    value ? scope.upcoming : scope
  end
end

filter :group, :integer do
  eq do |scope, value|
    scope.where(group_id: value)
  end
end
```

### Filter Types

| Type | Description | Example |
|------|-------------|---------|
| `:string` | Text filters | `filter :name, :string` |
| `:integer` | Number filters | `filter :age, :integer` |
| `:boolean` | True/false | `filter :active, :boolean` |
| `:datetime` | Date/time with operators | `filter :created_at, :datetime` |
| `:date` | Date only | `filter :birthday, :date` |
| `:float` | Decimal numbers | `filter :price, :float` |
| `:array` | Array of values | `filter :ids, :array` |

### Filter Operators (New Feature!)

Graphiti supports multiple operators per filter:

```ruby
filter :created_at, :datetime do
  eq  { |scope, val| scope.where(created_at: val) }
  gt  { |scope, val| scope.where('created_at > ?', val) }
  lt  { |scope, val| scope.where('created_at < ?', val) }
  gte { |scope, val| scope.where('created_at >= ?', val) }
  lte { |scope, val| scope.where('created_at <= ?', val) }
end
```

**Frontend usage:**
```javascript
// Equals (default)
?filter[created_at]=2024-01-01

// Greater than
?filter[created_at][gt]=2024-01-01

// Less than
?filter[created_at][lt]=2024-12-31

// Range (between)
?filter[created_at][gte]=2024-01-01&filter[created_at][lte]=2024-12-31
```

### Search Filter

The application-wide search filter was converted to:

```ruby
# In ApplicationResource
filter :search, :string do
  eq do |scope, value|
    searchable = self.class.config[:searchable_fields] || []
    return scope if searchable.empty?

    arel = scope.model.arel_table
    value.to_s.split.each do |word|
      conditions = searchable.map { |field| 
        arel[field].lower.matches("%#{word.downcase}%") 
      }.inject(:or)
      scope = scope.where(conditions)
    end
    scope
  end
end

# Define searchable fields in child resources
def self.searchable_fields(*fields)
  if fields.any?
    config[:searchable_fields] = fields
  else
    config[:searchable_fields] || []
  end
end
```

**In child resources:**
```ruby
class V1::UserResource < V1::ApplicationResource
  searchable_fields :email, :first_name, :last_name, :nickname
end
```

---

## Testing

### RSpec Request Specs

The request specs should mostly work unchanged since the API contract is the same.

**Key differences to test:**

1. **Pagination meta format:**
```ruby
expect(json['meta']['page']['total_pages']).to eq(5)
```

2. **Error responses:**
```ruby
expect(json['errors'].first['meta']['attribute']).to eq('name')
```

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific resource specs
bundle exec rspec spec/resources/

# Run request specs
bundle exec rspec spec/requests/
```

---

## Files Changed

### New Files
- `config/initializers/graphiti.rb`
- `app/controllers/concerns/graphiti_crud.rb`
- `GRAPHITI_MIGRATION.md` (this file)

### Removed Files
- `config/initializers/jsonapi_resources.rb`

### Modified Files

#### Gemfile
- Removed jsonapi-resources gems
- Added graphiti gems

#### Controllers (30+ files)
- `app/controllers/application_controller.rb`
- `app/controllers/v1/application_controller.rb`
- `app/controllers/v1/*_controller.rb` (all resource controllers)
- `app/controllers/v1/debit/*_controller.rb`
- `app/controllers/v1/form/*_controller.rb`
- `app/controllers/v1/forum/*_controller.rb`

#### Resources (26 files)
- `app/resources/v1/application_resource.rb`
- `app/resources/v1/*_resource.rb` (all resources)
- `app/resources/v1/debit/*_resource.rb`
- `app/resources/v1/form/*_resource.rb`
- `app/resources/v1/forum/*_resource.rb`

#### Routes
- `config/routes.rb`

---

## Troubleshooting

### Common Issues

#### 1. "undefined method `model`"
Make sure to set `self.model = ModelClass` in your resource.

#### 2. Filter not working
Check that:
- Filter type is correct (`:boolean`, `:string`, etc.)
- You're using `eq do |scope, value|` block syntax

#### 3. Relationships not loading
Ensure you specify the resource class:
```ruby
has_one :author, resource: V1::UserResource
```

#### 4. Context not available
Access context via `context` method, not instance variable:
```ruby
def current_user
  context&.dig(:user)
end
```

---

## Resources

- [Graphiti Documentation](https://www.graphiti.dev/guides/)
- [Graphiti GitHub](https://github.com/graphiti-api/graphiti)
- [JSON:API Specification](https://jsonapi.org/)
