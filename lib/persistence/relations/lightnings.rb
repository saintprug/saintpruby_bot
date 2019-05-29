class Lightnings < ROM::Relation[:redis]
  gateway :redis
  schema {}
end
