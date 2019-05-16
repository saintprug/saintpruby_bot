require 'dry/system/container'

class Application < Dry::System::Container
  configure do |config|
    config.name = :saintpruby_bot
    config.auto_register = %w(lib)
  end

  load_paths!('lib')
end
