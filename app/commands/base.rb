require 'forwardable'

module Commands
  class Base
    extend Forwardable
    include KeyboardHelpers

    attr_reader :api

    def initialize(api)
      @api = api
    end

    def call(message)
      case message
      when Telegram::Bot::Types::Message
        handle_call(message)
      when Telegram::Bot::Types::CallbackQuery
        args = JSON.parse(message.data)['args']
        handle_callback(message, args)
      end
    end

    private

    def_delegators :api, :send_message, :edit_message_text

    def handle_call(message)
      raise NotImplementedError, "you have to implement #{self.class.name}#handle_call"
    end

    def handle_callback(callback, args)
      raise NotImplementedError, "you have to implement #{self.class.name}#handle_callback"
    end
  end
end
