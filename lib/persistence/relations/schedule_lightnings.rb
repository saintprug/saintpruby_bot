class ScheduleLightnings < ROM::Relation[:yaml]
  gateway :default

  schema do
    attribute :id, ROM::Types::Integer
    attribute :datetime, ROM::Types::DateTime, read: ROM::Types::DateTime.constructor(DateTime.method(:parse))
  end
end
