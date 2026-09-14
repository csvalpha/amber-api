# AI Dev Guide - AMBER API

## Env
Container: `development-environment-alpha-1`
Path in container: `~/amber-api`
Shell: Must use `/bin/bash -l` for PATH
CMD: `docker exec -it development-environment-alpha-1 /bin/bash -l -c "cd ~/amber-api && bundle exec <cmd>"`
Direct: Enter container, `cd ~/amber-api`, then run `bundle exec <cmd>`

## Rules
1. Follow existing patterns
2. Tests for everything (95%+ coverage)
3. Follow RuboCop or document exception with reason
4. Keep it simple: convention over configuration
5. Don't add gems unless they have real benefit (student-maintained, avoid bloat)

## RuboCop
Config: `.rubocop.yml`
Target: Rails 7.2, Ruby 3.3, NewCops: enable
Disabled: HttpPositionalArguments, HasManyOrHasOneDependent, InverseOf, LexicallyScopedActionFilter, RSpec/LeadingSubject, Documentation, FrozenStringLiteralComment, GuardClause
Modified: RSpec/NestedGroups Max:5, Style/ClassAndModuleChildren excludes v1 resources, Metrics/BlockLength excludes spec/**
Exceptions: Must explain why in .rubocop.yml comments

## Structure
Resources: `app/resources/v1/*.rb` extends `V1::ApplicationResource < JSONAPI::Resource`
Tests: `spec/resources/v1/*_spec.rb` type: :resource
Factories: `spec/factories/*.rb` use FactoryBot + Faker

## Resource Template
```ruby
# app/resources/v1/model_resource.rb
class V1::ModelResource < V1::ApplicationResource
  attributes :attr1, :attr2
  has_one :user
  has_many :items
  filter :field
  
  def self.creatable_fields(context)
    %i[attr1 attr2]
  end
  
  def self.updatable_fields(context)
    creatable_fields(context)
  end
  
  def self.searchable_fields
    %i[attr1 attr2]
  end
end
```

## Test Template
```ruby
# spec/resources/v1/model_resource_spec.rb
require 'rails_helper'

RSpec.describe V1::ModelResource, type: :resource do
  let(:user) { create(:user) }
  let(:context) { { user: } }

  describe '#creatable_fields' do
    it { expect(described_class.creatable_fields(context)).to match_array(%i[attr1 attr2]) }
  end

  describe '#updatable_fields' do
    it { expect(described_class.updatable_fields(context)).to match_array(%i[attr1 attr2]) }
  end
end
```

## Factory Template
```ruby
# spec/factories/models.rb
FactoryBot.define do
  factory :model do
    user
    attr1 { Faker::Lorem.word }
    attr2 { [true, false].sample }
  end
end
```

## Test What
Resources: creatable_fields, updatable_fields, fetchable_fields, searchable_fields, filters, relationships, attributes, permissions
Models: validations, associations, scopes, methods, callbacks
Controllers: auth, Pundit policies, response codes, response body, error handling

## Commands
Test all: `bundle exec rspec`
Test file: `bundle exec rspec spec/path/to/file_spec.rb`
Test line: `bundle exec rspec spec/path/to/file_spec.rb:12`
RuboCop: `bundle exec rubocop`
RuboCop fix: `bundle exec rubocop -a`
Guard: `bundle exec guard`
DB: `bundle exec rails db:migrate`, `bundle exec rails g migration Name`

## Docker Commands
Enter: `docker exec -it development-environment-alpha-1 /bin/bash -l` then `cd ~/amber-api`
Start: `cd "C:/Users/jorai/Programeren/1. Alpha/1. Development/amber-api" && docker-compose -f docker-compose.development.yml up -d api`
Stop: `docker-compose -f docker-compose.development.yml down`
Logs: `docker logs development-environment-alpha-1`

## Pitfalls
- Don't use `docker exec ... bundle exec ...` directly (PATH + working dir issues)
- Don't skip tests
- Don't ignore RuboCop
- Don't use hash rockets `{:key => val}` except in excluded dirs
- Don't over-engineer
- Don't use `_context` param if unused (keep it for consistency)
- Do use existing patterns from ApplicationResource for permissions
