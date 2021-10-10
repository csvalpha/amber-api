require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'app/jobs/sentry_job.rb'

  minimum_coverage 95
  minimum_coverage_by_file 95
end

require 'pundit/rspec'
require 'vcr'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = false
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  Kernel.srand config.seed
end

RSpec::Matchers.define_negated_matcher :a_string_excluding, :a_string_including

# See https://github.com/vcr/vcr#vcr
VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end
