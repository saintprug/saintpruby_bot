module Commands
  class Vote < Base
    def call(message)
      vote_button = Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Like', callback_data: { command: 'like' }.to_json)]
      )
      send_message(chat_id: message.chat.id, text: 'Like this talk', reply_markup: vote_button)
    end
  end
end
