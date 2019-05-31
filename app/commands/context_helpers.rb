module Commands
  module ContextHelpers
    def username_for(user_object)
      user_object.username || "#{user_object.first_name} #{user_object.last_name}"
    end
  end
end
