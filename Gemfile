# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.3'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'rake'

# debug
gem 'pry'
gem 'pry-byebug'

# boot
gem 'dotenv'
gem 'dry-system'

# storage
gem 'redis'
gem 'rom'
gem 'rom-yaml'
gem 'rom-redis', :github => 'rom-rb/rom-redis'

# service api
gem 'telegram-bot-ruby', '~> 0.9.0', require: 'telegram/bot'

# fast JSON processing
gem 'oj'
gem 'multi_json'

# web & app server
gem 'iodine'
gem 'rack'

# tests
group :test do
  gem 'rspec'
  gem 'timecop'
end

group :ci do
  gem 'rspec_junit_formatter'
end
