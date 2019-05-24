module Commands
  class Vote < Base
    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: 'Like this talk',
        reply_markup: inline_keyboard(button('Like', 'vote'))
      )
    end

    def handle_callback(callback, args)
      # redis.publish('liker_bot', message.from.username)
      api.answer_callback_query(callback_query_id: callback.id)
    end
  end
end
