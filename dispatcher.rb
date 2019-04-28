class Dispatcher
  COMMANDS = %i[
    start
    schedule
    vote
    speakers
    places
    job_board
    stop
  ]

  SCHEDULE = File.read('schedule.txt')

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

  def dispatch_callback(message)
    if message.data == 'like'
      # redis.publish('liker_bot', message.from.username)
      bot.api.answer_callback_query(callback_query_id: message.id)
    end
  end

  def dispatch_message(message)
    command = message.text.gsub('/','').to_sym
    if COMMANDS.include?(command)
      send(command, message)
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I can't understand you")
    end
  end

  def start(ctx)
    bot.api.send_message(chat_id: ctx.chat.id, text: 'Hello')
  end

  def schedule(ctx)
    bot.api.send_message(chat_id: ctx.chat.id, text: SCHEDULE, parse_mode: :markdown)
  end

  def speakers(ctx)
  end

  def places(ctx)
  end

  def job_board(ctx)
  end

  def vote(ctx)
    vote_button = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Like', callback_data: 'like')]
    )
    bot.api.send_message(chat_id: ctx.chat.id, text: 'Like this talk', reply_markup: vote_button)
  end

  def stop(ctx)
    kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    bot.api.send_message(chat_id: ctx.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
  end
end
