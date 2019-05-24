module Commands
  class Vote < Base
    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: 'Like this talk',
        reply_markup: inline_keyboard(button('Like', 'like'))
      )
    end
  end
end
