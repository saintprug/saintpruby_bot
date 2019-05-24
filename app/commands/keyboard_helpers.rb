module Commands
  # ```
  # inline_keyboard(button('btn1', 'command', user_id: 1))
  # ```
  #
  # becomes
  #
  # ```
  # Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [
  #   Telegram::Bot::Types::InlineKeyboardButton.new(
  #     text: 'btn1',
  #     callback_data: { command: 'command', args: { user_id: 1 } }.to_json
  #   )
  # ])
  # ```
  #
  # ```
  # reply_keyboard(button('btn1'))
  # ```
  #
  # becomes
  #
  # ```
  # Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [
  #   Telegram::Bot::Types::KeyboardButton.new(text: 'btn1')
  # ])
  # ```
  #
  module KeyboardHelpers
    Button = Struct.new(:text, :command, :args)

    def self.included(base)
      base.extend(ClassMethods)
    end

    private

    def inline_keyboard(*args)
      self.class.inline_keyboard(*args)
    end

    def reply_keyboard(*args)
      self.class.reply_keyboard(*args)
    end

    def button(*args)
      self.class.button(*args)
    end

    module ClassMethods
      def inline_keyboard(*buttons)
        Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: buttons_to_markup(buttons, :inline)
        )
      end

      def reply_keyboard(*buttons)
        Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: buttons_to_markup(buttons, :reply)
        )
      end

      def button(text, command='', args={})
        Button.new(text, command, args)
      end

      private

      def buttons_to_markup(buttons, keyboard_type)
        if buttons.all? { |elem| elem.is_a?(Array) }
          buttons.map { |btn_block| buttons_to_markup(btn_block, keyboard_type) }
        elsif buttons.all? { |elem| elem.is_a?(Button) }
          buttons.map do |button|
            case keyboard_type
            when :inline then inline_button_markup(button)
            when :reply then reply_button_markup(button)
            end
          end
        end
      end

      def inline_button_markup(button)
        data = { command: button.command, args: button.args }.to_json
        raise ArgumentError, 'callback_data is too big' if data.bytesize > 64

        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: button.text,
          callback_data: data
        )
      end

      def reply_button_markup(button)
        Telegram::Bot::Types::KeyboardButton.new(text: button.text)
      end
    end
  end
end
