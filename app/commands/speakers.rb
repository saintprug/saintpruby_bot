module Commands
  class Speakers < Base
    SPEAKERS = File.read('./data/speakers.txt')

    def call(message)
      send_message(
        chat_id: message.chat.id,
        text: SPEAKERS,
        parse_mode: :markdown
      )
    end
  end
end
