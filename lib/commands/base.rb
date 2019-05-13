require 'forwardable'

module Commands
  class Base
    extend Forwardable

    attr_reader :api

    def initialize(api)
      @api = api
    end

    def_delegators :api, :send_message, :edit_message
  end
end
