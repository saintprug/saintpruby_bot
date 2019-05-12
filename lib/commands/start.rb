# frozen_string_literal: true

module Commands
  class Start < Base
    def call
      bot_api.send_message(
        chat_id: chat_id,
        text: I18n.t('commands.start', full_name: current_user.full_name)
      )
    end
  end
end
