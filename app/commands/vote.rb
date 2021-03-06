module Commands
  class Vote < Base
    include Import[:redis]

    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: 'Press to like an ongoing talk',
        reply_markup: inline_keyboard(button('❤️🧡💛💚💙💜', 'vote'))
      )
    end

    def handle_callback(callback, args)
      redis.publish('liker_bot', callback.from.username)
      api.answer_callback_query(callback_query_id: callback.id)
    end
  end
end
