RSpec.describe Commands::Beers do
  describe '#call' do
    let(:api) { double('api', send_message: nil) }
    let(:chat) { Telegram::Bot::Types::Chat.new(id: 1) }
    let(:message) { Telegram::Bot::Types::Message.new(chat: chat) }
    let(:beer_service) { instance_double(Services::Beer) }

    subject { described_class.new(api, beer_service: beer_service).call(message) }

    context 'user drinks too fast' do
      before do
        allow(beer_service).to receive(:last).and_return(Time.now)
        allow(beer_service).to receive(:drinks_fast?).and_return(true)
        allow(beer_service).to receive(:time_to_drink).and_return(Time.now + 60 * 5)
        allow(beer_service).to receive(:user_total_by_last_day).and_return(10)
      end

      it 'returns warning message'do
        expect(api).to receive(:send_message).with(
          chat_id: 1,
          text: /we have a timeout/,
          parse_mode: :markdown
        )
        subject
      end
    end

    context 'user drinks normal mode' do
      let(:joke) { 'How many fingers are there?' }

      before do
        allow(beer_service).to receive(:drink)
        allow(beer_service).to receive(:scale_of_drunkness).and_return(joke)
        allow(beer_service).to receive(:last).and_return(Time.now - 60 * 5)
        allow(beer_service).to receive(:drinks_fast?).and_return(false)
        allow(beer_service).to receive(:user_total_by_last_day).and_return(10)
      end

      it 'returns joke'do
        expect(api).to receive(:send_message).with(
          chat_id: 1,
          text: /#{joke}/,
          parse_mode: :markdown
        )
        subject
      end
    end
  end
end
