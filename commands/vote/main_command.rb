# frozen_string_literal: true

require_relative '../base_command'

module Commands
  module Vote
    class MainCommand < BaseCommand
      def call
        vote_button = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Like', callback_data: { command: 'like' }.to_json)]
        )
        bot.api.send_message(
          chat_id: context.chat.id,
          text: 'Like this talk',
          reply_markup: vote_button
        )
      end
    end
  end
end
