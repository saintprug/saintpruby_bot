module Commands
  class Back < Start
    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: 'Choose from the commands below:',
        reply_markup: MENU_KEYBOARD
      )
    end
  end
end
