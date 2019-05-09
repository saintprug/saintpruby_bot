# frozen_string_literal: true

module Commands
  class BaseCommand
    attr_reader :bot, :context

    def initialize(bot, context)
      @bot = bot
      @context = context
    end

    def call
      raise NotImplementedError
    end
  end
end
