# frozen_string_literal: true

require_relative '../base_command'
require 'yaml'

module Commands
  module Jobs
    class MainCommand < BaseCommand
      JOBS = YAML.load_file("#{__dir__}/../../data/jobs.yml")

      def call
        JOBS.each_with_index do |job, i|
          text = "*#{job['title']}*\nCompany: #{job['company']}\nLocation: #{job['location']}\n#{job['announce']}"
          more_button = Telegram::Bot::Types::InlineKeyboardMarkup.new(
            inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(
                                text: 'Show more',
                                callback_data: { command: 'jobs_more', job_id: i }.to_json
                              )]
          )
          bot.api.send_message(
            chat_id: context.chat.id,
            text: text,
            parse_mode: :markdown,
            reply_markup: more_button
          )
        end
      end
    end
  end
end
