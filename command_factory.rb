# frozen_string_literal: true

Dir[File.join('.', 'commands', '**', '*.rb')].each { |file| require file }

module CommandFactory
  module_function

  def get_command(bot, context)
    case context
    when Telegram::Bot::Types::Message
      namespace, command = context.text.gsub('/', '').split('_').map(&:capitalize)
    when Telegram::Bot::Types::CallbackQuery
      namespace, command = JSON.parse(context.data)['command'].gsub('/', '').split('_').map(&:capitalize)
    end

    command = 'Main' if command.nil?
    begin
      Commands.const_get("#{namespace}::#{command}Command").new(bot, context)
    rescue NameError
      Commands::NotFoundCommand.new(bot, context)
    end
  end
end
