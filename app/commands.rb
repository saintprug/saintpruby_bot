require_relative 'commands/keyboard_helpers'
require_relative 'commands/base'
Dir['./app/commands/*.rb'].each { |f| require f.delete_prefix('app/') }

module Commands
  Error = Class.new(StandardError)
  FallbackError = Class.new(Error)
end
