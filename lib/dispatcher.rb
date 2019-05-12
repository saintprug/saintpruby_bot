# frozen_string_literal: true

require_relative 'commands/base'
require_relative 'commands/start'
require_relative 'commands/stop'
require_relative 'commands/jobs'
require_relative 'commands/schedule'
require_relative 'commands/speakers'

class Dispatcher
  include CurrentUserHelper

  COMMANDS = {
    '/start' => Commands::Start,
    '/stop' => Commands::Stop,
    '/jobs' => Commands::Jobs,
    '/schedule' => Commands::Schedule,
    '/speakers' => Commands::Speakers
  }.freeze

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

  def dispatch_message(message)
    if COMMANDS.key?(message.text)
      command_class = COMMANDS[message.text]
      command_class.call(
        current_user: current_user(chat_data: message.chat),
        bot_api: bot.api,
        chat_id: message.chat.id
      )
    else
      bot.api.send_message(chat_id: message.chat.id, text: I18n.t('errors.unknown_command'))
    end
  end

  def dispatch_callback(callback_query); end
end
