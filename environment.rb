# frozen_string_literal: true

require 'bundler'
require 'logger'

require 'singleton'
require 'redis'

Bundler.require
Dotenv.load

Dir[File.expand_path 'lib/**/*.rb'].each { |file_name| require(file_name) }
I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']

class Storage
  include Singleton

  attr_accessor :client

  class << self
    def client
      instance.client
    end

    def client=(value)
      instance.client ||= value
    end
  end
end

Storage.client = Redis.new
