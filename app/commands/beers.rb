module Commands
  class Beers < Base
    include Import[beer_service: 'services.beer']

    private

    def handle_call(message)
      chat_id = message.chat.id

      if beer_service.last(chat_id) && beer_service.drinks_fast?(chat_id)
        message = ['*Easy, you*', '*Who drives you home*?', '*What are you, Homer Simpson?*'].sample
      else
        beer_service.drink(chat_id)
        message = "#{beer_service.scale_of_drunkness(chat_id)}.\nAlready drunk: #{'🍻' * beer_service.user_total(chat_id)}"
      end

      send_message(
        chat_id: chat_id,
        text: message,
        parse_mode: :markdown
      )
    end
  end
end
