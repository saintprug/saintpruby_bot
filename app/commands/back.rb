module Commands
  class Back < Base
    MESSAGE_TEXT = 'Choose from the commands below:'

    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: MESSAGE_TEXT,
        reply_markup: Keyboards::MainReplyKeyboard.new.call
      )
    end

    def handle_callback(callback, args)
      delete_message(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id
      ) if args.fetch('replace', false)

      send_message(
        chat_id: callback.message.chat.id,
        text: MESSAGE_TEXT,
        reply_markup: Keyboards::MainReplyKeyboard.new.call
      )
    end
  end
end
