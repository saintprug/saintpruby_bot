module Commands
  module Keyboards
    class MainReplyKeyboard
      include KeyboardHelpers

      def call
        reply_keyboard(
          [ button('📆 Schedule'), button('❤️ Vote') ],
          [ button('🎤 Speakers'), button('💵 Jobs') ],
          [ button('🍻 Drunk beer!'), button('📌 Locations') ],
          [ button('⚡ Lightnings') ]
        )
      end
    end
  end
end
