module Entities
  class DrunkBeer < ROM::Struct
    CoercibleTime = ROM::Types::String.constructor do |value|
      ::Time.parse(value)
    rescue ArgumentError
      nil
    end

    attribute :user_id, ROM::Types::Coercible::String
    attribute :drunk_at, ROM::Types::Strict::Array.of(CoercibleTime)
  end
end
