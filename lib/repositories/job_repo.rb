module Repositories
  class JobRepo < ROM::Repository[:jobs]
    include ArgsImport['rom']

    def by_id(id)
      jobs.by_pk(id)
    end

    def all
      jobs.to_a
    end
  end
end
