module Repositories
  class TalkRepo < ROM::Repository[:talks]
    include ArgsImport['rom']

    def by_date(date)
      talks.select { |talk| talk.datetime.to_date == date }.sort_by(&:datetime)
    end

    def by_id(id)
      talks.find { |talk| talk.id == id }
    end
  end
end
