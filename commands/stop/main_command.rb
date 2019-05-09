# frozen_string_literal: true

require_relative '../base_command'

module Commands
  module Stop
    class MainCommand < BaseCommand
      def call
        kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        bot.api.send_message(
          chat_id: context.chat.id,
          text: 'Sorry to see you go :(',
          reply_markup: kb
        )
      end
    end
  end
end
