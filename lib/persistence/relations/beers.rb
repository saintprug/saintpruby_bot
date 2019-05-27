class Beers < ROM::Relation[:redis]
  gateway :redis
  schema {}
end
