# frozen_string_literal: true

require_relative 'command_factory'

class Dispatcher
  def initialize(bot)
    @bot = bot
  end

  def call(message)
    CommandFactory.get_command(bot, message).call
  end

  private

  attr_reader :bot
end
