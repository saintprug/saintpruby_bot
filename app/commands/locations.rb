module Commands
  class Locations < Base
    LOCATIONS = YAML.load_file('data/locations.yml')['locations']

    LOCATION_SELECTION_KEYBOARD = inline_keyboard(
      [
        button('🎤 Conference', 'locations', location: 'conference'),
        button('🍻 Afterparty', 'locations', location: 'afterparty')
      ]
    )

    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: "Which location are you interested in?",
        parse_mode: :markdown,
        reply_markup: LOCATION_SELECTION_KEYBOARD
      )
    end

    def handle_callback(callback, args)
      location = LOCATIONS[args.fetch('location')]

      edit_message_text(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id,
        text: location['description'],
        parse_mode: :markdown
      )

      send_location(
        chat_id: callback.message.chat.id,
        latitude: location['lat'],
        longitude: location['lon']
      )
    end
  end
end
