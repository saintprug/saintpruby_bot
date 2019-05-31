module Commands
  module Keyboards
    class LightningsKeyboard
      include KeyboardHelpers

      def call(cancel_button: false)
        reply_keyboard(
          [button('📆 Lightnings schedule')],
          [
            button('🎤 Book a lightning talk'),
            (button('🗙 Cancel my booking') if cancel_button)
          ].compact,
          [button('◀️ Back')]
        )
      end
    end
  end
end
