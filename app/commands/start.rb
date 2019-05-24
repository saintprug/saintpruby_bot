module Commands
  class Start < Base
    MENU_KEYBOARD = reply_keyboard(
      [ button('📆 Schedule'), button('❤️ Vote') ],
      [ button('🎤 Speakers'), button('💵 Jobs') ],
      [ button('🍻 Beer counter'), button('🏛 Places') ]
    )

    WELCOME_TEXT = """
      💎 Hi wild Rubyist! I'm Saint P Rubyconf Bot 💎

      *What can I do for you?*
    """.freeze

    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: WELCOME_TEXT,
        parse_mode: :markdown,
        reply_markup: MENU_KEYBOARD
      )
    end
  end
end
