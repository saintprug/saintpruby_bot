RSpec.describe Commands::KeyboardHelpers do
  let(:dummy_class) do
    Class.new do
      include Commands::KeyboardHelpers

      def inline_keyboard(*args); super; end
      def reply_keyboard(*args); super; end
      def button(*args); super; end
    end
  end

  let(:dummy) { dummy_class.new }

  describe '#inline_keyboard' do
    subject(:keyboard) do
      dummy.inline_keyboard(
        dummy.button('btn1', 'command', user_id: 1),
        dummy.button('btn2', 'command', user_id: 2)
      )
    end

    it 'produces correct inline keyboard markup' do
      expect(keyboard.to_compact_hash).to eq (
        Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'btn1',
            callback_data: { command: 'command', args: { user_id: 1 } }.to_json
          ),
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'btn2',
            callback_data: { command: 'command', args: { user_id: 2 } }.to_json
          )
        ])
      ).to_compact_hash
    end

    context 'when callback_data is not longer 64 bytes' do
      subject(:keyboard) do
        # callback_data length = 64
        dummy.inline_keyboard(dummy.button('text', 'command', user_id: '1'*21))
      end

      it { expect { keyboard }.not_to raise_error }
    end

    context 'when callback_data is longer that 64 bytes' do
      subject(:keyboard) do
        # callback_data length = 65
        dummy.inline_keyboard(dummy.button('text', 'command', user_id: '1'*22))
      end

      it { expect { keyboard }.to raise_error(ArgumentError) }
    end
  end

  describe '#reply_keyboard' do
    subject(:keyboard) do
      dummy
        .reply_keyboard(dummy.button('btn1'), dummy.button('btn2'))
        .to_compact_hash
    end

    it 'produces correct reply keyboard markup' do
      is_expected.to eq (
        Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [
          Telegram::Bot::Types::KeyboardButton.new(text: 'btn1'),
          Telegram::Bot::Types::KeyboardButton.new(text: 'btn2')
        ])
      ).to_compact_hash
    end
  end
end
