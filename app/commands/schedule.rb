module Commands
  class Schedule < Base
    include Import[repo: 'repositories.talk_repo']

    CONFDAY_SELECTION_KEYBOARD = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [[
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'June 1, Sat', callback_data: { command: 'schedule', args: { confday: 1 } }.to_json),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'June 2, Sun', callback_data: { command: 'schedule', args: { confday: 2 } }.to_json)
      ]]
    )

    # 🕓 18:00 🎤 Hiroshi Shibata
    # 🚩 *The Future of library dependency management of Ruby*

    def call(message)
      case message
      when Telegram::Bot::Types::Message
        handle_message(message)
      when Telegram::Bot::Types::CallbackQuery
        args = JSON.parse(message.data)['args']
        handle_callback(message, args)
      end
    end

    private

    def handle_message(message)
      send_message(
        chat_id: message.chat.id,
        text: 'Choose a day:',
        reply_markup: CONFDAY_SELECTION_KEYBOARD
      )
    end

    def handle_callback(message, args)
      date = Date.new(2019, 06, args.fetch('confday'))
      talks = repo.by_date(date)

      edit_message_text(
        message_id: message.message.message_id,
        chat_id: message.message.chat.id,
        text: talks_message(date, talks),
        parse_mode: :markdown
      )
    end



    def talks_message(confday, talks)
      <<~MARKDOWN
        *——— #{confday.strftime('%B %d, %a')} ———*

        #{talks.map { |talk| talk_string(talk) }.join("\n")}
      MARKDOWN
    end

    def talk_string(talk)
      <<~MARKDOWN
        🕓 #{talk.datetime.strftime('%H:%M')} #{"🎤 #{talk.speaker}" if talk.speaker}
        🚩 *#{talk.title}*
      MARKDOWN
    end
  end
end
