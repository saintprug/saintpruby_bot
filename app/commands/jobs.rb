module Commands
  class Jobs < Base
    include Import[repo: 'repositories.job_repo']

    # TODO: send in portions since sending messages is rate limited with 30 calls/sec
    def handle_call(message)
      repo.all.each do |job|
        text =  <<~MARKDOWN
          *#{job.title}*
          Company: #{job.company}
          Location: #{job.location}
          #{job.short_description}
        MARKDOWN

        send_message(
          chat_id: message.chat.id,
          text: text,
          parse_mode: :markdown,
          reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
            inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(
              text: 'Show more',
              callback_data: { command: 'jobs', args: { job_id: job.id } }.to_json
            )]
          )
        )
      end
    end

    def handle_callback(callback, args)
      job = repo.by_id(args.fetch('job_id'))

      text = <<~MARKDOWN
        *#{job.title}*
        Company: #{job.company}
        Location: #{job.location}
        #{job.full_description}
      MARKDOWN

      edit_message_text(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id,
        text: text,
        parse_mode: :markdown
      )
    end
  end
end
