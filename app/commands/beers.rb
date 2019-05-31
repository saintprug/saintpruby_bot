module Commands
  class Beers < Base
    include Import[beer_service: 'services.beer']

    WRONG_TIME_MESSAGES = [
      "⌛ They've paid me only for the evening hours ⌛",
      "⌛ Hey, the party has not yet started! ⌛"
    ]

    private

    def handle_call(message)
      chat_id = message.chat.id

      if wrong_time?
        message = wrong_time_message
      elsif drinks_too_fast?(chat_id)
        message = too_fast_message(chat_id)
      else
        beer_service.drink(chat_id)
        message = scale_of_drunkness_message(chat_id)
      end

      send_message(
        chat_id: chat_id,
        text: message,
        parse_mode: :markdown
      )
    end

    def wrong_time?
      (6..18).cover?(Time.now.getlocal('+03:00').hour)
    end

    def drinks_too_fast?(chat_id)
      beer_service.drinks_fast?(chat_id)
    end

    def wrong_time_message
      <<~MARKDOWN
        #{WRONG_TIME_MESSAGES.sample}
        _(This command works from 19:00 till 6:00)_
      MARKDOWN
    end

    def too_fast_message(chat_id)
      <<~MARKDOWN
        ⏳ I don't believe you are drinking that fast ⌛
        (we have a 60 seconds timeout between glasses, try again after #{next_drink_adviced_time(chat_id)})
        _Already drunk today: #{drunkness_scale(chat_id)}_
      MARKDOWN
    end

    def scale_of_drunkness_message(chat_id)
      <<~MARKDOWN
        #{beer_service.scale_of_drunkness(chat_id)}.
        _Already drunk today: #{drunkness_scale(chat_id)}_
      MARKDOWN
    end

    def drunkness_scale(chat_id)
      '🍻' * beer_service.user_total_by_last_day(chat_id)
    end

    def next_drink_adviced_time(chat_id)
      beer_service.time_to_drink(chat_id).localtime('+03:00').strftime('%T')
    end
  end
end
