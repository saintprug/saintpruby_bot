# frozen_string_literal: true

require_relative 'base_command'

module Commands
  class NotFoundCommand < BaseCommand
    def call
      bot.api.send_message(
        chat_id: context.chat.id,
        text: "I can't understand you"
      )
    end
  end
end
