# frozen_string_literal: true

require_relative '../base_command'

module Commands
  module Schedule
    class MainCommand < BaseCommand
      SCHEDULE = File.read("#{__dir__}/../../data/schedule.txt")

      def call
        bot.api.send_message(
          chat_id: context.chat.id,
          text: SCHEDULE,
          parse_mode: :markdown
        )
      end
    end
  end
end
