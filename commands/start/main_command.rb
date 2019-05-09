# frozen_string_literal: true

require_relative '../base_command'

module Commands
  module Start
    class MainCommand < BaseCommand
      HELP = File.read("#{__dir__}/../../data/help.txt")

      def call
        bot.api.send_message(
          chat_id: context.chat.id,
          text: HELP,
          parse_mode: :markdown
        )
      end
    end
  end
end
