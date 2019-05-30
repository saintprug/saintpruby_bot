class Dispatcher
  def initialize(bot)
    @fallback = Commands::Unknown.new(bot.api)

    @commands = {
      '/start' => Commands::Start.new(bot.api),
      '📆 Schedule' => Commands::Schedule.new(bot.api),
      '❤️ Vote' => Commands::Vote.new(bot.api),
      '🎤 Speakers' => Commands::Speakers.new(bot.api),
      '💵 Jobs' => Commands::Jobs.new(bot.api),
      '🍻 Drunk beer!' => Commands::Beers.new(bot.api),
      '📌 Locations' => Commands::Locations.new(bot.api),
      '◀️ Back' => Commands::Back.new(bot.api),
      '/talk' => Commands::Talk.new(bot.api),
      '⚡ Lightnings' => Commands::LightningTalks.new(bot.api),
      '📆 Lightnings schedule' => Commands::LightningTalksSchedule.new(bot.api),
      '🎤 Book a lightning talk' => Commands::BookLightningTalks.new(bot.api)
    }

    @callbacks = {
      'vote' => commands['❤️ Vote'],
      'schedule' => commands['📆 Schedule'],
      'jobs' => commands['💵 Jobs'],
      'lightning' => commands['📆 Lightnings schedule'],
      'book' =>  commands['🎤 Book a lightning talk'],
      'locations' => commands['📌 Locations']
    }
  end

  def call(message)
    case message
    when Telegram::Bot::Types::Message
      dispatch_message(message)
    when Telegram::Bot::Types::CallbackQuery
      dispatch_callback(message)
    end
  end

  private

  attr_reader :commands, :callbacks, :fallback

  def dispatch_message(message)
    command_name = message.text.sub(/_\d+$/, '')
    handler = commands.fetch(command_name, fallback)

    handler.call(message)
  rescue Commands::UnexpectedInputError
    fallback.call(message)
  end

  def dispatch_callback(callback)
    callback_name = JSON.parse(callback.data)['command']
    handler = callbacks.fetch(callback_name, fallback)

    handler.call(callback)
  rescue JSON::ParserError, Commands::UnexpectedInputError
    fallback.call(callback)
  end
end
