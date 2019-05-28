class Talks < ROM::Relation[:yaml]
  gateway :default

  schema do
    attribute :id, ROM::Types::Integer
    attribute :title, ROM::Types::String
    attribute :speaker, ROM::Types::String
    attribute :description, ROM::Types::String
    attribute :datetime, ROM::Types::DateTime, read: ROM::Types::DateTime.constructor(DateTime.method(:parse))
  end

  auto_struct true
end
