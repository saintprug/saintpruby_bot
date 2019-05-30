module Commands
  class BookLightningTalks < Base
    include Import[
      book_lightning_repo: 'repositories.book_lightning_repo',
      schedule_lightning_repo: 'repositories.schedule_lightning_repo',
      lightning_talk_service: 'services.lightning_talk'
    ]

    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: '🧐 *Choose one of the free slots below*',
        parse_mode: :markdown,
        reply_markup: inline_keyboard(*free_lightning_slots(message.chat))
      )
    end

    def handle_callback(callback, args)
      from = callback.from
      username = from.username || "#{from.first_name} #{from.last_name}"
      id = args['args']

      datetime = schedule_lightning_repo.by_id(id).datetime

      lightnings = book_lightning_repo.create(username: username, datetime: datetime.to_s)

      send_message(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id,
        text: "Well done! Booked at #{datetime.strftime('%d/%m %H:%M')}",
        parse_mode: :markdown
      )
    end

    def free_lightning_slots(chat)
      lightning_talk_service.mapping_with_schedule_and_booked_talks do |booked, schedule|
        datetime = schedule.datetime.to_datetime

        next if booked[datetime]

        button(datetime.strftime('%d/%m %H:%M'), 'book', args: schedule.id)
      end.compact
    end
  end
end
