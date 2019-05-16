require 'bundler'
Bundler.require

require_relative 'system/container'
require_relative 'dispatcher'

Dotenv.load

# 🕓 18:00 🎤 Hiroshi Shibata
# 🚩 *The Future of library dependency management of Ruby*

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_API_TOKEN'], logger: Application['logger']) do |bot|
  dispatcher = Dispatcher.new(bot)

  bot.listen do |message|
    bot.logger.info(message)
    dispatcher.call(message)
  end
end
