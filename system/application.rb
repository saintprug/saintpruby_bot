require 'dry/system/container'
require 'dry/system/components'

class Application < Dry::System::Container
  configure do |config|
    config.auto_register = %w(lib)
  end

  load_paths!('lib')
end
