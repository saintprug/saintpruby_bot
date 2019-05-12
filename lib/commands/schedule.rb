# frozen_string_literal: true

module Commands
  class Schedule < Base
    def call
      bot_api.send_message(
        chat_id: chat_id,
        text: command_content(:schedule),
        parse_mode: :markdown
      )
    end
  end
end
