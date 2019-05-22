RSpec.describe Commands::Talk do
  describe '#call' do
    let(:api) { double('api', send_message: nil) }
    let(:command) { described_class.new(api) }

    let(:chat) { Telegram::Bot::Types::Chat.new(id: 1) }
    let(:message) do
      Telegram::Bot::Types::Message.new(chat: chat, message_id: 2, text: '/talk_123')
    end

    let(:talk) do
      Application['repositories.talk_repo'].talks.mapper.model.new(
        id: 123,
        title: 'abrakadabra',
        speaker: 'Joan Doe',
        description: 'cool talk!',
        datetime: DateTime.parse('2019-06-01T12:00:00+0300')
      )
    end

    before do
      allow_any_instance_of(Repositories::TalkRepo).to receive(:by_id).with(123) { talk }
    end

    it 'responds to correct chat' do
      expect(api).to receive(:send_message).with(include(chat_id: 1))

      command.call(message)
    end

    it 'responds with text containing date, time, speaker, title and description' do
      expected =        match(/June 0?1/)
                   .and(match(/12:00/))
                   .and(match(/Joan Doe/))
                   .and(match(/abrakadabra/))
                   .and(match(/cool talk!/))
      expect(api).to receive(:send_message).with(include(text: expected))

      command.call(message)
    end

    it 'responds with vote keyboard' do
      pending("Let's implement vote command first")
      fail
    end
  end
end
