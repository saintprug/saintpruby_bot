require 'logger'
require 'bundler'
Bundler.require

Dotenv.load

logger = Logger.new(STDOUT)

Telegram::Bot::Client.run(ENV['TOKEN'], logger: logger) do |bot|
  dispatcher = Dispatcher.new(bot)

  bot.listen do |message|
    bot.logger.info(message)
    dispatcher.call(message)
  end
end
