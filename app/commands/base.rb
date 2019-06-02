require 'forwardable'

module Commands
  class Base
    extend Forwardable
    include KeyboardHelpers
    include ContextHelpers

    include Import['logger']

    attr_reader :api

    def initialize(api, **deps)
      @api = api
      super(deps)
    end

    def call(message)
      case message
      when Telegram::Bot::Types::Message
        handle_call(message)
      when Telegram::Bot::Types::CallbackQuery
        args = JSON.parse(message.data)['args']
        handle_callback(message, args)
      end
    rescue Telegram::Bot::Exceptions::ResponseError => e
      logger.error("Error: #{e.message}\n#{e.backtrace.join("\n")}")
    end

    private

    def_delegators :api, :send_message, :edit_message_text,
                         :send_location, :delete_message, :send_photo

    def handle_call(message)
      raise NotImplementedError, "you have to implement #{self.class.name}#handle_call"
    end

    def handle_callback(callback, args)
      raise NotImplementedError, "you have to implement #{self.class.name}#handle_callback"
    end
  end
end
