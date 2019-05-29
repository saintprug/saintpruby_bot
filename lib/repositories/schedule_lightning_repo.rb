module Repositories
  class ScheduleLightningRepo < ROM::Repository[:schedule_lightnings]
    include ArgsImport['rom']

    def all
      schedule_lightnings.to_a
    end

    def by_date(date)
      schedule_lightnings.select { |lightning| lightning.datetime.to_date == date }.sort_by(&:datetime)
    end

    def by_id(id)
      schedule_lightnings.find { |lightning| lightning.id == id }
    end
  end
end
