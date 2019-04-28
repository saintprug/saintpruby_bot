require 'logger'
require 'bundler'
Bundler.require

Dotenv.load

logger = Logger.new(STDOUT)

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_API_TOKEN'], logger: logger) do |bot|
  dispatcher = Dispatcher.new(bot)

  bot.listen do |message|
    bot.logger.info(message)
    dispatcher.call(message)
  end
end
