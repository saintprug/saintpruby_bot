module Relations
  class Talks < ROM::Relation[:yaml]
    schema(:talks) do
      attribute :title, ROM::Types::String
      attribute :speaker, ROM::Types::String
      attribute :description, ROM::Types::String
      attribute :datetime, ROM::Types::DateTime
    end

    auto_struct true

    def by_date(date)
      restrict(datetime: date)
    end
  end
end
