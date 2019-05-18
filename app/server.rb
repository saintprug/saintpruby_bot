class Server
  def self.run!
    Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_API_TOKEN'], logger: Application['logger']) do |bot|
      dispatcher = Dispatcher.new(bot)

      bot.listen do |message|
        bot.logger.info(message)
        dispatcher.call(message)
      end
    end
  end
end
