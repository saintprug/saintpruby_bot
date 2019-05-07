module Dispatchers
  class Job
    JOBS = YAML.load_file('./data/jobs.yml')

    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    def more(callback)
      data = JSON.parse(callback.data)
      job = JOBS.detect { |j| j['id'] == data['job_id'] }
      text = "*#{job['title']}*\nCompany: #{job['company']}\nLocation: #{job['location']}\n#{job['announce']}\n#{job['full_description']}"
      bot.api.edit_message_text(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id,
        text: text,
        parse_mode: :markdown
      )
    end

    def jobs(ctx)
      JOBS.each_with_index do |job, i|
        text = "*#{job['title']}*\nCompany: #{job['company']}\nLocation: #{job['location']}\n#{job['announce']}"
        more_button = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(
                              text: 'Show more',
                              callback_data: { command: 'more', job_id: i }.to_json
                            )]
        )
        bot.api.send_message(chat_id: ctx.chat.id, text: text, parse_mode: :markdown, reply_markup: more_button)
      end
    end
  end
end
