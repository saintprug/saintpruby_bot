module Repositories
  class BeerRepo < ROM::Repository[:beers]
    include ArgsImport['rom']

    def create(attributes)
      beers.map_to(Entities::DrunkBeer).command(:create).call(attributes)
    end

    def find_by_user_id(user_id)
      drunk_at = beers.with(auto_struct: false).lrange(user_id, 0, -1)

      mapper = -> (drunk_at) do
        [{ user_id: user_id, drunk_at: drunk_at.first }]
      end

      mapped = drunk_at >> mapper

      mapped.map_to(Entities::DrunkBeer).one
    end

    def all
      user_ids = beers.with(auto_struct: false).keys('*')

      mapper = -> (user_ids) do
        user_ids.first.map do |user_id|
          drunk_at = beers.with(auto_struct: false).lrange(user_id, 0, -1).first
          { user_id: user_id, drunk_at: drunk_at }
        end
      end

      mapped = user_ids >> mapper

      mapped.map_to(Entities::DrunkBeer).to_a
    end
  end
end
