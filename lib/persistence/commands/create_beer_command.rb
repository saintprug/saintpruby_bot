class CreateBeerCommand < ROM::Commands::Create
  class CreateBeerCommandError < StandardError; end

  relation :beers
  register_as :create

  result :one

  def execute(user_id:, drunk_at:)
    result = relation.rpush(user_id, drunk_at).first
    if result
      drunk_at = relation.with(auto_struct: false).lrange(user_id, 0, -1).first
      [{ user_id: user_id, drunk_at: drunk_at }]
    else
      raise CreateBeerCommandError
    end
  end
end
