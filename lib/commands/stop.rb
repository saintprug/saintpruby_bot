# frozen_string_literal: true

module Commands
  class Stop < Base
    def call
      bot_api.send_message(
        chat_id: chat_id, text: I18n.t('commands.stop_message'),
        reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
      )
    end
  end
end
