RSpec.describe Commands::Start do
  describe '#call' do
    let(:api) { double('api', send_message: nil) }
    let(:chat) { Telegram::Bot::Types::Chat.new(id: 1) }
    let(:message) {Telegram::Bot::Types::Message.new(chat: chat) }

    subject { described_class.new(api).call(message) }

    it 'sends welcome message to channel' do
      expect(api).to receive(:send_message).with(
        chat_id: 1,
        text: Commands::Start::WELCOME_TEXT,
        parse_mode: :markdown,
        reply_markup: Commands::Start::MENU_KEYBOARD
      )
      subject
    end
  end
end
