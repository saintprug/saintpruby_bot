module Commands
  class Rubizza < Base
    SELECTION_KEYBOARD = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Sign up for free',
          url: 'https://spb.rubizza.com'
        ),
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Learn more (link VK)',
          url: 'https://vk.com/rubizza'
        )
      ]
    )

    def handle_call(message)
      send_photo(
        parse_mode: :markdown,
        chat_id: message.chat.id,
        caption: '*———💎😈 Ruby survival camp 😈💎 ———*',
        photo: 'AgADAgAD-6kxG4ajkUtxDL9B-sIj3SdKOQ8ABC3GymTHlXixJUIGAAEC',
        reply_markup: SELECTION_KEYBOARD
      )
    end
  end
end
