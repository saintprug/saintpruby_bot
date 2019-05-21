class Talks < ROM::Relation[:yaml]

  schema(infer: true) do
    attribute :title, ROM::Types::String
    attribute :speaker, ROM::Types::String
    attribute :description, ROM::Types::String
    attribute :datetime, ROM::Types::DateTime
  end

  auto_struct true

  def datetime(datetime)
    talks.select { |t| t[:datetime] > datetime && t[:datetime] < next_day.to_date.to_datetime }
  end

  def short
    project(:title, :speaker, :datetime)
  end
end
