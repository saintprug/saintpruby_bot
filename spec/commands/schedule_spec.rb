RSpec.describe Commands::Schedule do
  describe '#call' do
    let(:api) { double('api', send_message: nil) }
    let(:command) { described_class.new(api) }

    let(:chat) { Telegram::Bot::Types::Chat.new(id: 1) }
    let(:message) { Telegram::Bot::Types::Message.new(chat: chat, message_id: 2) }

    context 'STEP 1: command recieves /schedule message' do
      subject(:schedule) { command.call(message) }

      it 'responds with confday selection message' do
        expect(api).to receive(:send_message).with(
          chat_id: 1,
          text: 'Choose a day:',
          reply_markup: described_class::CONFDAY_SELECTION_KEYBOARD
        )

        schedule
      end
    end

    context 'STEP 2: command recieves a callback with confday selected' do
      subject(:schedule) { command.call(callback) }

      let(:data) { { command: 'schedule', args: { confday: 1 } } }
      let(:callback) do
        Telegram::Bot::Types::CallbackQuery.new(message: message, data: data.to_json)
      end

      it 'responds with talks for selected day' do
        expect(api).to receive(:edit_message_text).with(
          chat_id: 1,
          message_id: 2,
          text: be_a(String),
          parse_mode: :markdown
        )

        schedule
      end
    end
  end
end
