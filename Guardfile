require 'active_support/inflector'

guard :rspec, cmd: 'bundle exec spring rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w[erb haml slim])
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  watch(%r{app/controllers/((.+)/)?application_controller.rb}) { 'spec/requests' }
  watch(%r{^app/controllers/(.+)/(.+)_(controller)\.rb$}) do |m|
    "spec/requests/#{m[1]}/#{m[2]}_#{m[3]}"
  end

  watch('app/policies/application_policy.rb') { 'spec/requests' }
  watch(%r{^app/policies/(.+)_(policy)\.rb$}) do |m|
    Dir[File.join("spec/requests/**/#{m[1].pluralize}_controller")]
  end

  watch(%r{^app/resources/(.+)_(resource)\.rb$}) do |m|
    Dir[File.join("spec/requests/**/#{m[1].pluralize}_controller")]
  end

  # Rails config changes
  watch(rails.spec_helper)     { rspec.spec_dir }
  watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
  watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

  # Capybara features specs
  watch(rails.view_dirs)     { |m| rspec.spec.call("features/#{m[1]}") }
  watch(rails.layouts)       { |m| rspec.spec.call("features/#{m[1]}") }

  # Helper specs
  watch(%r{^spec/helpers/(.+)_spec\.rb$})

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance'
  end
end
