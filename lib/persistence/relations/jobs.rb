class Jobs < ROM::Relation[:yaml]

  schema(infer: true) do
    attribute :id, ROM::Types::Integer
    attribute :title, ROM::Types::String
    attribute :company, ROM::Types::String
    attribute :location, ROM::Types::String
    attribute :short_description, ROM::Types::String
    attribute :full_description, ROM::Types::String
  end

  auto_struct true

  def by_pk(id)
    restrict(id: id)
  end
end
