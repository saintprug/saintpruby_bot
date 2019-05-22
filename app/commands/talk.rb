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
    # [ ❤️ (11) ] [ 💩 (2) ]
    #
    def handle_call(message)
      id = message.text[%r{(?<=^/talk_)\d+$}]&.to_i
      return nil unless id

      talk = repo.by_id(id)

      # TODO: show vote results if user had already voted for a given talk
      # TODO: allow users to revote
      send_message(
        chat_id: message.chat.id,
        text: talk_message(talk),
        parse_mode: :markdown,
        reply_markup: vote_keyboard(message.chat.id, talk.id)
      )
    end

    private

    def vote_keyboard(user_id, talk_id)
      inline_keyboard(
        [
          button('❤️', 'vote', tid: talk_id, uid: user_id, v: '❤️'),
          button('💩', 'vote', tid: talk_id, uid: user_id, v: '💩')
        ]
      )
    end

    def talk_message(talk)
      <<~MARKDOWN.gsub(/^\s*\n\z/, '')
        🕓 #{talk.datetime.strftime('%B %d, %a, %H:%M')} #{"🎤 #{talk.speaker}" if talk.speaker}
        🚩 *#{talk.title}*

        #{"ℹ️ #{talk.description}" if talk.description}
      MARKDOWN
    end
  end
end
