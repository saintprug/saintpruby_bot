module Commands
  class Schedule < Base
    include Import[repo: 'repositories.talk_repo']

    # 🕓 18:00 🎤 Hiroshi Shibata
    # 🚩 *The Future of library dependency management of Ruby*

    def call(message)
      schedule_keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [[
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'June 1, Sat', callback_data: { command: 'schedule', args: 1 }.to_json),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'June 2, Sun', callback_data: { command: 'schedule', args: 2 }.to_json)
        ]]
      )
      send_message(
        chat_id: message.chat.id,
        text: 'Choose a day:',
        reply_markup: schedule_keyboard
      )
    end
  end
end
