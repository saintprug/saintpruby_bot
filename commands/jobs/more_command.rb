# frozen_string_literal: true

require_relative '../base_command'
require 'yaml'

module Commands
  module Jobs
    class MoreCommand < BaseCommand
      JOBS = YAML.load_file("#{__dir__}/../../data/jobs.yml")

      def call
        data = JSON.parse(context.data)
        job = JOBS.detect { |j| j['id'] == data['job_id'] }
        text = "*#{job['title']}*\nCompany: #{job['company']}\nLocation: #{job['location']}\n#{job['announce']}\n#{job['full_description']}"
        bot.api.edit_message_text(
          message_id: context.message.message_id,
          chat_id: context.message.chat.id,
          text: text,
          parse_mode: :markdown
        )
      end
    end
  end
end
