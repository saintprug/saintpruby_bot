module Commands
  class Talk < Base
    include Import[repo: 'repositories.talk_repo']

    # 🕓 18:00 🎤 Hiroshi Shibata
    # 🚩 *The Future of library dependency management of Ruby*
    #
    # ℹ️ I did merge Bundler into Ruby core repository and shipped bundler as standard library on Ruby 2.6. It provides any fresh installation of Ruby with gem and bundle commands.
    #
    # I'm going to show the features of Bundler and RubyGems and the integration plan of RubyGems and Bundler. Also I will show the issues of the current state. You can resolve them after my talk.
    #
    def handle_call(message)
      id = message.text[%r{(?<=^/talk_)\d+$}]&.to_i || raise(FallbackError)
      talk = repo.by_id(id) || raise(FallbackError)

      send_message(
        chat_id: message.chat.id,
        text: talk_message(talk),
        parse_mode: :markdown
      )
    end

    private

    def talk_message(talk)
      <<~MARKDOWN.gsub(/^\s*\n\z/, '')
        🕓 #{talk.datetime.strftime('%B %d, %a, %H:%M')} #{"🎤 #{talk.speaker}" if talk.speaker}
        🚩 *#{talk.title}*

        #{"ℹ️ #{talk.description}" if talk.description}
      MARKDOWN
    end
  end
end
