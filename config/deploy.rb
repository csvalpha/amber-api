# Deploy is done via buildkite, see .buildkite directory
# This file is for mina to be able to connect to the rails console on the server

require 'mina/rails'
import 'lib/mina/tasks/rails.rake'

set :domain, 'csvalpha.nl'

task :staging do
  set :deploy_to, '/opt/docker/amber-api/staging'
end

task :production do
  set :deploy_to, '/opt/docker/amber-api/production'
end
