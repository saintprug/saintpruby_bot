require 'bundler'

Bundler.require

begin
  require 'pry-byebug'
rescue LoadError
end

Dotenv.load

require_relative 'application'

root = Application.root

Import = Application.injector
ArgsImport = Import.args

Dir.glob(root.join('system/boot/*.rb')).each { |f| require f }
Dir.glob(root.join('app/*.rb')).each { |f| require f }

Application.finalize!
