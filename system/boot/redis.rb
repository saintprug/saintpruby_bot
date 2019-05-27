Application.boot(:redis) do |application|
  start do
    use :logger

    redis = Redis.new(
      url: ENV['REDIS_URL'],
      logger: application[:logger]
    )

    register(:redis, redis)
  end
end
