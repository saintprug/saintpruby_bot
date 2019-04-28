module Services
  class Beer
    def initialize(id)
      @id = id
    end

    def drink
      REDIS_CONNECTION.rpush(key, Time.now)
    end

    def last
      @last ||= REDIS_CONNECTION.lindex(key, -1)
    end

    def total
      keys = REDIS_CONNECTION.keys('beer:*')

      keys.map do |key|
        REDIS_CONNECTION.lrange(key, 0, -1).count
      end.reduce(:+)
    end

    def key
      "beer:#{id}"
    end

    def drinks_fast?
      (Time.parse(last) + 60 * 5) > Time.now
    end

    private

    attr_reader :id
  end
end
