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
        photo: 'https://pp.userapi.com/c841629/v841629196/1b9a/RJZWFgu4_2o.jpg',
        reply_markup: SELECTION_KEYBOARD
      )
    end
  end
end
