module Services
  class LightningTalk
    include Import[
      book_lightning_repo: 'repositories.book_lightning_repo',
      schedule_lightning_repo: 'repositories.schedule_lightning_repo'
    ]

    def available_slots
      booked = book_lightning_repo.all.map { |booking| booking.datetime.to_datetime }
      schedule_lightning_repo.all.reject { |slot| booked.include?(slot.datetime.to_datetime) }
    end

    def mapping_with_schedule_and_booked_talks
      booked = book_lightning_repo.all.each_with_object({}) { |lightning, hash| hash[lightning.datetime.to_datetime] = lightning.username }

      schedule_lightning_repo.all.map do |lightning|
        yield(booked, lightning)
      end
    end

    def book(username, slot)
      cancel_booking(username) if has_booking?(username)
      book_lightning_repo.create(username: username, datetime: slot.datetime.to_s)
    end

    def cancel_booking(username)
      slot = book_lightning_repo.by_username(username)
      book_lightning_repo.delete(slot.datetime)
    end

    def has_booking?(username)
      !book_lightning_repo.by_username(username).nil?
    end
  end
end
