require 'relations/jobs'
require 'relations/talks'

Application.boot(:rom) do
  init do
    require 'rom'
  end

  start do
    configuration = ROM::Configuration.new(:yaml, 'data')
    configuration.register_relation(Relations::Jobs)
    configuration.register_relation(Relations::Talks)
    # configuration.auto_registration('lib')
    container = ROM.container(configuration)
    register(:rom, container)
  end
end
