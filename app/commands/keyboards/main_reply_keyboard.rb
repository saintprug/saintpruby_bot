module Commands
  module Keyboards
    class MainReplyKeyboard
      include KeyboardHelpers

      def call
        reply_keyboard(
          [ button('📆 Schedule'), button('❤️ Vote') ],
          [ button('🎤 Speakers'), button('💵 Jobs') ],
          [ button('🍻 Beer-in!'), button('📌 Locations') ],
          [ button('⚡ Lightnings'), button('🤓 Rubizza') ]
        )
      end
    end
  end
end
