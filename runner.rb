# frozen_string_literal: true

require_relative 'environment'

logger = Logger.new("log/#{ENV['ENVIRONMENT']}.log")

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_API_TOKEN'], logger: logger) do |bot|
  dispatcher = Dispatcher.new(bot)

  bot.listen do |message|
    bot.logger.info(message)
    dispatcher.call(message)
  end
end
