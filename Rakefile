begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end

namespace :server do
  desc "Start a bot server"
  task :start do
    require_relative 'system/boot'
    Server.run!
  end
end
