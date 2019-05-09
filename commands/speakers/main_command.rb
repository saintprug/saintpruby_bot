# frozen_string_literal: true

require_relative '../base_command'

module Commands
  module Speakers
    class MainCommand < BaseCommand
      SPEAKERS = File.read("#{__dir__}/../../data/speakers.txt")

      def call
        bot.api.send_message(
          chat_id: context.chat.id,
          text: SPEAKERS,
          parse_mode: :markdown,
          disable_web_page_preview: true
        )
      end
    end
  end
end
