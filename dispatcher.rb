require 'yaml'

require_relative 'dispatchers/job'

class Dispatcher
  COMMANDS = %i[
    start
    schedule
    vote
    speakers
    places
    jobs
    stop
  ]

  SCHEDULE = File.read('./data/schedule.txt')
  SPEAKERS = File.read('./data/speakers.txt')
  HELP = File.read('./data/help.txt')

  def initialize(bot)
    @bot = bot
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

  attr_reader :bot

  def dispatch_callback(callback)
    begin
      command = JSON.parse(callback.data)['command']
    rescue JSON::ParserError
      return nil
    end

    if command == 'like'
      # redis.publish('liker_bot', message.from.username)
      # Dispatchers::Like.new(...)
      bot.api.answer_callback_query(callback_query_id: callback.id)
    elsif command == 'more'
      Dispatchers::Job.new(bot).more(callback)
    end
  end

  def dispatch_message(message)
    command = message.text.gsub('/', '').to_sym

    if COMMANDS.include?(command)
      send(command, message)
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I can't understand you")
    end
  end

  def start(ctx)
    bot.api.send_message(chat_id: ctx.chat.id, text: HELP, parse_mode: :markdown)
  end

  def schedule(ctx)
    bot.api.send_message(chat_id: ctx.chat.id, text: SCHEDULE, parse_mode: :markdown)
  end

  def speakers(ctx)
    bot.api.send_message(
      chat_id: ctx.chat.id,
      text: SPEAKERS,
      parse_mode: :markdown,
      disable_web_page_preview: true
    )
  end

  def places(ctx)
  end

  def jobs(ctx)
    Dispatchers::Job.new(bot).jobs(ctx)
  end

  def vote(ctx)
    vote_button = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Like', callback_data: { command: 'like' }.to_json)]
    )
    bot.api.send_message(chat_id: ctx.chat.id, text: 'Like this talk', reply_markup: vote_button)
  end

  def stop(ctx)
    kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    bot.api.send_message(chat_id: ctx.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
  end
end
