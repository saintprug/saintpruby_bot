module Repositories
  class JobRepo < ROM::Repository[:jobs]
    include ArgsImport['rom']

    def by_id(id)
      jobs.restrict(id: id).first
    end

    def all
      jobs.to_a
    end
  end
end
