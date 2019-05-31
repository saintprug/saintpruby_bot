module Commands
  module LightningTalks
    class Schedule < Base
      include Import[
        lightning_talk_service: 'services.lightning_talk'
      ]

      private

      def handle_call(message)
        send_message(
          message_id: message.message_id,
          chat_id: message.chat.id,
          text: decorated_schedule,
          parse_mode: :markdown
        )
      end

      def schedule
        lightning_talk_service.mapping_with_schedule_and_booked_talks do |booked, schedule|
          username = booked.fetch(schedule.datetime, '‼️  FREE SLOT (You can book this time!)')
          "🕓 #{schedule.datetime.strftime('%H:%M')} 🎤 #{username}"
        end
      end

      def decorated_schedule
        <<~MARKDOWN
          *--- 📆 Lightnings schedule ---*

          #{schedule.join("\n\n")}
        MARKDOWN
      end
    end
  end
end
