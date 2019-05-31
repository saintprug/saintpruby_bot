module Commands
  module LightningTalks
    class CancelBooking < Base
      include Import[
        lightning_talks: 'services.lightning_talk',
      ]

      private

      def handle_call(message)
        username = username_for(message.from)
        lightning_talks.cancel_booking(username)

        send_message(
          chat_id: message.chat.id,
          text: 'Your booking has been canceled',
          reply_markup: Keyboards::LightningsKeyboard.new.call(
            cancel_button: lightning_talks.has_booking?(username)
          )
        )
      end
    end
  end
end
