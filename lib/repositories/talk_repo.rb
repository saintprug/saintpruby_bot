module Repositories
  class TalkRepo < ROM::Repository[:talks]
    include ArgsImport['rom']

    def later_that_day
      talks.by_datetime(DateTime.now)
    end
  end
end
