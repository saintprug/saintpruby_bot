require 'json'

class Dispatcher
  COMMANDS = %i[
    start
    schedule
    vote
    speakers
    places
    job_board
    stop
    talk
  ]

  SCHEDULE = File.read('./data/schedule.txt')
  SPEAKERS = File.read('./data/speakers.txt')
  TALK_DESCRIPTIONS = JSON.parse(File.read('./data/talk_descriptions.json'))
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

  def dispatch_callback(message)
    if message.data == 'like'
      # redis.publish('liker_bot', message.from.username)
      bot.api.answer_callback_query(callback_query_id: message.id)
    end
  end

  def dispatch_message(message)
    command = message.text.to_s.gsub(%r{\A/|_\d+\z}, '').to_sym

    COMMANDS.include?(command) ? send(command, message) : bad_command(message)
  end

  def start(ctx)
    bot.api.send_message(chat_id: ctx.chat.id, text: HELP, parse_mode: :markdown)
  end

  def schedule(ctx)
    bot.api.send_message(chat_id: ctx.chat.id, text: SCHEDULE, parse_mode: :markdown)
  end

  def talk(ctx)
    talk_id = ctx.text.delete_prefix('/talk_')
    return bad_command(ctx) unless TALK_DESCRIPTIONS.key?(talk_id)

    bot.api.send_photo(
      chat_id: ctx.chat.id,
      photo: TALK_DESCRIPTIONS[talk_id]['photo'],
      caption: TALK_DESCRIPTIONS[talk_id]['caption']
    )
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

  def bad_command(ctx)
    bot.api.send_message(chat_id: ctx.chat.id, text: "I can't understand you")
  end
end
