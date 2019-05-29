module Services
  class LightningTalk
    include Import[
      book_lightning_repo: 'repositories.book_lightning_repo',
      schedule_lightning_repo: 'repositories.schedule_lightning_repo'
    ]

    def free_lightning_slots(chat)
      booked = book_lightning_repo.all.each_with_object({}) { |lightning, hash| hash[lightning.datetime.to_datetime] = lightning.username }

      schedule_lightning_repo.all.map do |lightning|
        datetime = lightning.datetime.to_datetime
        next if booked[datetime]

        button(lightning.datetime.strftime('%d/%m %H:%M'), 'book', args: lightning.id)
      end.compact
    end

    def mapping_with_schedule_and_booked_talks
      booked = book_lightning_repo.all.each_with_object({}) { |lightning, hash| hash[lightning.datetime.to_datetime] = lightning.username }

      schedule_lightning_repo.all.map do |lightning|
        yield(booked, lightning)
      end
    end
  end
end
