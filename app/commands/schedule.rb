module Commands
  class Schedule < Base
    include Import[repo: 'repositories.talk_repo']

    CONFDAY_SELECTION_KEYBOARD = inline_keyboard(
      [
        button('June 1, Sat', 'schedule', confday: 1),
        button('June 2, Sun', 'schedule', confday: 2)
      ]
    )

    private

    # Choose a day:
    # [ June 1, Sat ] [ June 2, Sun ]
    #
    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: 'Choose a day:',
        reply_markup: CONFDAY_SELECTION_KEYBOARD
      )
    end

    # 🕓 18:00 🎤 Hiroshi Shibata
    # 🚩 *The Future of library dependency management of Ruby*
    #
    # ...
    #
    def handle_callback(callback, args)
      date = Date.new(2019, 06, args.fetch('confday'))
      talks = repo.by_date(date)

      edit_message_text(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id,
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
