module Commands
  class Beers < Base
    private

    def handle_call(message)
      
    end

    def drink_beer(message)
      beer_service = Services::Beer.new(message.chat.id)

      if beer_service.last && beer_service.drinks_fast?
        bot.api.send_message(
          chat_id: message.chat.id,
          text: ['Easy, you', 'Who drives you home?', 'What are you, Homer Simpson?'].sample
        )
      else
        beer_service.drink

        giphy = GiphyClient.new.send_request

        bot.api.send_animation(
          chat_id: message.chat.id,
          animation: giphy[:data][:fixed_height_small_url]
        )
      end
    end

    def total_drunk_beer(message)
      beer_service = Services::Beer.new(message.chat.id)

      bot.api.send_message(
        chat_id: message.chat.id,
        text: beer_service.total
      )
    end
  end
end
