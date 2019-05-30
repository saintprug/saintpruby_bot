RSpec.describe Commands::Locations do
  let(:api) { double('api', send_message: nil) }
  let(:command) { described_class.new(api) }

  let(:chat) { Telegram::Bot::Types::Chat.new(id: 1) }
  let(:message) { Telegram::Bot::Types::Message.new(chat: chat, message_id: 2) }

  describe 'direct call' do
    it 'responds with location selection message' do
      expect(api).to receive(:send_message).with(
        chat_id: 1,
        text: 'Which location are you interested in?',
        parse_mode: :markdown,
        reply_markup: described_class::LOCATION_SELECTION_KEYBOARD
      )

      command.call(message)
    end
  end

  describe 'callback' do
    let(:data) { { command: 'locations', args: { location: location_name } } }
    let(:callback) do
      Telegram::Bot::Types::CallbackQuery.new(message: message, data: data.to_json)
    end

    context 'when user requests `conference` location' do
      let(:location_name) { 'conference' }

      it "responds with location and it's description" do
        expect(api).to receive(:edit_message_text).with(
          chat_id: 1,
          message_id: 2,
          text: match(/conference/i),
          parse_mode: :markdown
        )

        expect(api).to receive(:send_location).with(
          chat_id: 1,
          latitude: 59.981662,
          longitude: 30.214774
        )

        command.call(callback)
      end
    end

    context 'when user requests `afterparty` location' do
      let(:location_name) { 'afterparty' }

      it "responds with location and it's description" do
        expect(api).to receive(:edit_message_text).with(
          chat_id: 1,
          message_id: 2,
          text: match(/afterparty/i),
          parse_mode: :markdown
        )

        expect(api).to receive(:send_location).with(
          chat_id: 1,
          latitude: 59.981832,
          longitude: 30.210642
        )

        command.call(callback)
      end
    end
  end
end
