class CreateBookLightningCommand < ROM::Commands::Create
  relation :lightnings
  register_as :create

  result :one

  def execute(username:, datetime:)
    relation.with(auto_struct: false).set(datetime, username).one
    [{ username: username, datetime: datetime }]
  end
end
