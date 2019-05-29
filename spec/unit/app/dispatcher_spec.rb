RSpec.describe Dispatcher do
  subject(:dispatcher) { described_class.new(bot) }

  let(:bot) { Telegram::Bot::Client.new('token') }
  let(:message) { Telegram::Bot::Types::Message.new(text: command_name) }

  let(:command) { instance_double(command_class) }
  let(:fallback_command) { instance_double(Commands::Unknown) }

  before do
    allow(command_class).to receive(:new) { command } if defined?(command_class)
    allow(Commands::Unknown).to receive(:new) { fallback_command }
  end

  describe 'on message' do
    context 'if command is recognized' do
      let(:command_class) { Commands::Schedule }
      let(:command_name) { '📆 Schedule' }

      it 'executes corresponding command' do
        expect(command).to receive(:call).with(message)
        dispatcher.call(message)
      end
    end

    context 'if command has trailing digits' do
      let(:command_class) { Commands::Talk }
      let(:command_name) { '/talk_123' }

      it 'strips trailing digits when recognizing commands' do
        expect(command).to receive(:call).with(message)
        dispatcher.call(message)
      end
    end

    context 'if command is not recognized' do
      let(:command_name) { 'hsbdflgkjs' }

      it 'executes fallback command' do
        expect(fallback_command).to receive(:call).with(message)
        dispatcher.call(message)
      end
    end

    context 'if recognized command raises FallbackError' do
      let(:command_class) { Commands::Talk }
      let(:command_name) { '\talk_123' }

      it 'executes fallback command' do
        allow(command).to receive(:call).and_raise(Commands::FallbackError)
        expect(fallback_command).to receive(:call).with(message)

        dispatcher.call(message)
      end
    end
  end

  describe 'on callback' do
    let(:data) { { command: callback_name, args: {} }.to_json }
    let(:callback) { Telegram::Bot::Types::CallbackQuery.new(data: data) }

    context 'if callback is recognized' do
      let(:command_class) { Commands::Schedule }
      let(:callback_name) { 'schedule' }

      it 'executes corresponding command' do
        expect(command).to receive(:call).with(callback)
        dispatcher.call(callback)
      end
    end

    context 'if callback is not recognized' do
      let(:callback_name) { 'ksjdflgsj' }

      it 'executes fallback command' do
        expect(fallback_command).to receive(:call).with(callback)
        dispatcher.call(callback)
      end
    end

    context 'if callback data is not parseable' do
      let(:callback_name) { 'jobs' }
      let(:data) { "not a JSON" }

      it 'executes fallback command' do
        expect(fallback_command).to receive(:call).with(callback)
        dispatcher.call(callback)
      end
    end

    context 'if recognized callback raises FallbackError' do
      let(:command_class) { Commands::Vote }
      let(:callback_name) { '❤️ Vote' }

      it 'executes fallback command' do
        allow(command).to receive(:call).and_raise(Commands::FallbackError)
        expect(fallback_command).to receive(:call).with(callback)

        dispatcher.call(callback)
      end
    end
  end
end
