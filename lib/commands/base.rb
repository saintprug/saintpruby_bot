# frozen_string_literal: true

module Commands
  class Base
    DATA_PATH = 'lib/data'

    def initialize(current_user:, bot_api:, chat_id:)
      @current_user = current_user

      @bot_api = bot_api
      @chat_id = chat_id
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      raise NotImplementedError, 'You need to follow the interface and define method #call'
    end

    private

    attr_reader :current_user, :bot_api, :chat_id

    def command_content(name, format = :txt)
      File.read("#{DATA_PATH}/#{name}.#{format}")
    end
  end
end
