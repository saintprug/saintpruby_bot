module Commands
  class Beers < Base
    include Import[beer_service: 'services.beer']

    private

    def handle_call(message)
      chat_id = message.chat.id

      if beer_service.last(chat_id) && beer_service.drinks_fast?(chat_id)
        message = <<~MARKDOWN
          ⏳ I don't believe you are drinking that fast ⌛ (we have a timeout 5 minutes between glasses, try again it after #{next_drink_adviced_time(chat_id)})
          _Already drunk today: #{'🍻' * beer_service.user_total_by_last_day(chat_id)}_
        MARKDOWN
      else
        beer_service.drink(chat_id)
        message = "#{beer_service.scale_of_drunkness(chat_id)}.\n_Already drunk today: #{'🍻' * beer_service.user_total_by_last_day(chat_id)}_"
      end

      send_message(
        chat_id: chat_id,
        text: message,
        parse_mode: :markdown
      )
    end

    def next_drink_adviced_time(chat_id)
      beer_service.time_to_drink(chat_id).localtime('+03:00').strftime('%T')
    end
  end
end
