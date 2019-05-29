module Entities
  class BookedLightning < ROM::Struct
    CoercibleTime = ROM::Types::String.constructor do |value|
      ::Time.parse(value)
    rescue ArgumentError
      nil
    end

    attribute :username, ROM::Types::Coercible::String
    attribute :datetime, CoercibleTime
  end
end
