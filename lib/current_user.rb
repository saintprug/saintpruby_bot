# frozen_string_literal: true

class CurrentUser
  attr_reader :id, :first_name, :last_name, :username

  def initialize(id:, first_name:, last_name:, username:)
    @id = id

    @first_name = first_name
    @last_name = last_name

    @username = username
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

module CurrentUserHelper
  private

  def current_user(chat_data:)
    @current_user ||= CurrentUser.new(
      id: chat_data.id,
      first_name: chat_data.first_name,
      last_name: chat_data.last_name,
      username: chat_data.username
    )
  end
end
