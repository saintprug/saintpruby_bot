module Commands
  class LightningTalks < Base
    MENU_KEYBOARD = reply_keyboard(
      [button('📆 Lightnings schedule')],
      [button('🎤 Book a lightning talk')],
      [button('◀️ Back')]
    )

    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: '📆 Choose an action 🎤',
        parse_mode: :markdown,
        reply_markup: MENU_KEYBOARD
      )
    end
  end
end
