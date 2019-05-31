module Commands
  class Lightnings < Base
    include Import[lightning_talks: 'services.lightning_talk']

    private

    def handle_call(message)
      username = username_for(message.from)

      send_message(
        chat_id: message.chat.id,
        text: '📆 Choose an action 🎤',
        parse_mode: :markdown,
        reply_markup: menu_keyboard_for(username)
      )
    end

    def menu_keyboard_for(username)
      reply_keyboard(
        [button('📆 Lightnings schedule')],
        [
          button('🎤 Book a lightning talk'),
          (button('🗙 Cancel my booking') if lightning_talks.has_booking?(username))
        ].compact,
        [button('◀️ Back')]
      )
    end
  end
end
