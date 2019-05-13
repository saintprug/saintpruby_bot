require_relative 'base'

module Commands
  class Start < Base
    MENU_KEYBOARD = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard:
      [
        [
          Telegram::Bot::Types::KeyboardButton.new(text: '📆 Schedule'),
          Telegram::Bot::Types::KeyboardButton.new(text: '❤️ Vote')
        ],
        [
          Telegram::Bot::Types::KeyboardButton.new(text: '🎤 Speakers'),
          Telegram::Bot::Types::KeyboardButton.new(text: '💵 Jobs')
        ],
        [
          Telegram::Bot::Types::KeyboardButton.new(text: '🍻 Beer counter'),
          Telegram::Bot::Types::KeyboardButton.new(text: '🏛 Places')
        ],
      ]
    )

    WELCOME_TEXT = """
      💎 Hi wild Rubyist! I'm Saint P Rubyconf Bot 💎

      *What can I do for you?*
    """.freeze

    def call(message)
      send_message(
        chat_id: message.chat.id,
        text: WELCOME_TEXT,
        parse_mode: :markdown,
        reply_markup: MENU_KEYBOARD
      )
    end
  end
end
