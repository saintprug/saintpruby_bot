Application.boot(:rom) do |app|
  init do
    require 'rom'
    require 'rom-repository'
  end

  start do
    configuration = ROM::Configuration.new(:yaml, app.root.join('data'))
    configuration.auto_registration(app.root.join('lib/persistence'), namespace: false)

    container = ROM.container(configuration)
    register(:rom, container)
  end
end
