module Commands
  class Unknown < Base
    MESSAGE_TEXT = "Didn't get it".freeze
    CALLBACK_TEXT = "I can't understand you".freeze

    private

    def handle_call(message)
      api.send_message(
        chat_id: message.chat.id,
        text: MESSAGE_TEXT
      )
    end

    def handle_callback(callback, args)
      api.answer_callback_query(
        callback_query_id: callback.id,
        text: CALLBACK_TEXT
      )
    end
  end
end
