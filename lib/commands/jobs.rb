require 'import'
require_relative 'base'

module Commands
  class Jobs < Base
    include Import['rom']

    def more(id)
      job = dataset.find { |j| j['id'] == id }

      text = ["*#{job['title']}*"]
      text << "Company: #{job['company']}"
      text << "Location: #{job['location']}"
      text << job['announce']
      text << job['full_description']
      text.join("\n")

      edit_message(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id,
        text: text,
        parse_mode: :markdown
      )
    end

    def call(message)
      dataset.each_with_index do |job, i|
        text = ["*#{job[:title]}*"]
        text << "Company: #{job[:company]}"
        text << "Location: #{job[:location]}"
        text << job[:short_description]
        text = text.join("\n")
        more_button = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'Show more',
            callback_data: { command: 'more', job_id: i }.to_json
          )]
        )
        send_message(chat_id: message.chat.id, text: text, parse_mode: :markdown, reply_markup: more_button)
      end
    end

    private

    def dataset
      @dataset ||= rom.relations['jobs'].dataset
    end
  end
end
