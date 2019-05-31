module Commands
  module LightningTalks
    class Book < Base
      include Import[
        book_lightning_repo: 'repositories.book_lightning_repo',
        schedule_lightning_repo: 'repositories.schedule_lightning_repo',
        lightning_talk_service: 'services.lightning_talk'
      ]

      private

      def handle_call(message)
        username = username_for(message.from)

        send_message(
          chat_id: message.chat.id,
          text: '🧐 *Choose one of the available slots below*',
          parse_mode: :markdown,
          reply_markup: inline_keyboard(*available_slot_buttons(username))
        )
      end

      def handle_callback(callback, args)
        id = args.fetch('id') { raise(FallbackError) }
        slot = schedule_lightning_repo.by_id(id) || raise(FallbackError)
        username = username_for(callback.from)
        confirmed = args.fetch('confirm', false)

        if !confirmed
          ask_for_confirmation(callback, username, slot)
        else
          lightning_talk_service.book(username, slot)
          report_success(callback, username, slot)
        end
      end

      def ask_for_confirmation(callback, username, slot)
        edit_message_text(
          message_id: callback.message.message_id,
          chat_id: callback.message.chat.id,
          text: "Slot at *#{slot.datetime.strftime('%d/%m, %H:%M')}* will be booked for *#{username}*",
          parse_mode: :markdown,
          reply_markup: inline_keyboard([
            button('Confirm', 'book', id: slot.id, confirm: true),
            button('Cancel', 'back', replace: true)
          ])
        )
      end

      def report_success(callback, username, slot)
        delete_message(
          message_id: callback.message.message_id,
          chat_id: callback.message.chat.id
        )

        send_message(
          chat_id: callback.message.chat.id,
          text: "Well done! Booked at #{slot.datetime.strftime('%d/%m %H:%M')}",
          parse_mode: :markdown,
          reply_markup: Keyboards::LightningsKeyboard.new.call(
            cancel_button: lightning_talk_service.has_booking?(username)
          )
        )
      end

      def available_slot_buttons(username)
        lightning_talk_service.available_slots.map do |slot|
          text = slot.datetime.strftime('%d/%m %H:%M')
          text += " (rebook)" if lightning_talk_service.has_booking?(username)

          button(text, 'book', id: slot.id)
        end
      end
    end
  end
end
