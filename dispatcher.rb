# frozen_string_literal: true

class Dispatcher
  COMMANDS = %i[
    start
    schedule
    schedule_day_1
    schedule_day_2
    vote
    speakers
    places
    job_board
    stop
  ].freeze

  SCHEDULE = File.read('data/schedule.json')

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

  def dispatch_callback(callback_query)
    command = callback_query.data.to_sym

    if command == :like
      bot.api.answer_callback_query(callback_query_id: callback_query.id)
    elsif COMMANDS.include?(command)
      send(command, chat_id: callback_query.message.chat.id)
    end
  end

  def dispatch_message(message)
    command = message.text.gsub('/', '').to_sym
    if COMMANDS.include?(command)
      send(command, chat_id: message.chat.id)
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I can't understand you")
    end
  end

  def start(chat_id:)
    bot.api.send_message(chat_id: chat_id, text: 'Hello', reply_markup: main_keyboard)
  end

  def schedule(chat_id:)
    bot.api.send_message(chat_id: chat_id, text: 'Schedule', reply_markup: schedule_keyboard)
  end

  def schedule_day_1(chat_id:)
    schedule_data = JSON.parse(SCHEDULE)
    
    data = schedule_data['day_1'].map do |day|
      day.values.join("\n")
    end.join("\n\n")

    bot.api.send_message(chat_id: chat_id, text: data, reply_markup: schedule_keyboard)
  end

  def schedule_day_2(chat_id:)
    schedule_data = JSON.parse(SCHEDULE)
    
    data = schedule_data['day_2'].map do |day|
      day.values.join("\n")
    end.join("\n\n")

    bot.api.send_message(chat_id: chat_id, text: data, reply_markup: schedule_keyboard)
  end

  def speakers(ctx); end

  def places(ctx); end

  def job_board(ctx); end

  def vote(chat_id:)
    vote_button = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Like', callback_data: 'like')]
    )
    bot.api.send_message(chat_id: ctx.chat.id, text: 'Like this talk', reply_markup: vote_button)
  end

  def stop(chat_id:)
    kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    bot.api.send_message(chat_id: chat_id, text: 'Sorry to see you go :(', reply_markup: kb)
  end

  def main_keyboard
    Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Schedule', callback_data: :schedule)
      ]
    )
  end

  def schedule_keyboard
    Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Day 1', callback_data: :schedule_day_1),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Day 2', callback_data: :schedule_day_2)
      ]
    )
  end
end
