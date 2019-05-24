RSpec.describe Commands::Unknown do
  let(:api) { double('api', send_message: nil) }
  let(:command) { described_class.new(api) }

  let(:chat) { Telegram::Bot::Types::Chat.new(id: 123) }
  let(:message) { Telegram::Bot::Types::Message.new(chat: chat) }

  describe 'on message' do
    it 'responds with unknown message text' do
      expect(api).to receive(:send_message).with(
        chat_id: 123,
        text: described_class::MESSAGE_TEXT
      )

      command.call(message)
    end
  end

  describe 'on callback' do
    let(:callback) do
      Telegram::Bot::Types::CallbackQuery.new(id: "456", message: message, data: "{}")
    end

    it 'responds with unknown callback text' do
      expect(api).to receive(:answer_callback_query).with(
        callback_query_id: "456",
        text: described_class::CALLBACK_TEXT
      )

      command.call(callback)
    end
  end
end
