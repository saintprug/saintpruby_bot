RSpec.describe Commands::Beers do
  before { Timecop.freeze(freeze_time) }
  after { Timecop.return }

  describe '#call' do
    let(:api) { double('api', send_message: nil) }
    let(:chat) { Telegram::Bot::Types::Chat.new(id: 1) }
    let(:message) { Telegram::Bot::Types::Message.new(chat: chat) }
    let(:beer_service) { instance_double(Services::Beer) }

    subject(:beer!) { described_class.new(api, beer_service: beer_service).call(message) }

    context 'when user reports a drink at a wrong time' do
      let(:freeze_time) { Time.parse("2019-05-30T#{rand(6..19)}:00:00") }

      it 'reports that the time is wrong' do
        expect(api).to receive(:send_message).with(
          chat_id: 1,
          parse_mode: :markdown,
          text: satisfy do |text|
            described_class::WRONG_TIME_MESSAGES.include?(text)
          end
        )

        beer!
      end

      it 'does not change beer count' do
        expect(beer_service).not_to receive(:drink)
        beer!
      end
    end

    context 'when user drinks too fast' do
      let(:freeze_time) { Time.parse('2019-05-30T20:00:00') }

      before do
        allow(beer_service).to receive(:last).and_return(Time.now)
        allow(beer_service).to receive(:drinks_fast?).and_return(true)
        allow(beer_service).to receive(:time_to_drink).and_return(Time.now + 60 * 5)
        allow(beer_service).to receive(:user_total_by_last_day).and_return(10)
      end

      it 'returns warning message'do
        expect(api).to receive(:send_message).with(
          chat_id: 1,
          text: /timeout/,
          parse_mode: :markdown
        )

        beer!
      end

      it 'does not change beer count' do
        expect(beer_service).not_to receive(:drink)
        beer!
      end
    end

    context 'user drinks normal mode' do
      let(:freeze_time) { Time.parse('2019-05-30T20:00:00') }
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
