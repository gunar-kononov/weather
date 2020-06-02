RSpec.describe Weather::CLI do
  it 'executes properly' do
    expect { system %(bin/weather -v) }.to output(Weather::VERSION + "\n").to_stdout_from_any_process
  end

  describe '.call' do
    let(:minimums) do
      Array.new(7) { Faker::Number.within(range: -50..0) }
    end

    let(:maximums) do
      Array.new(7) { Faker::Number.within(range: 0..50) }
    end

    let(:average_minimum) { minimums.sum(0.0) / minimums.length }
    let(:average_maximum) { maximums.sum(0.0) / maximums.length }
    let(:forecast) { minimums.zip(maximums) }
    let(:city) { 'Barcelona' }

    let(:source) do
      source = double
      allow(source).to receive(:temperature).with(city).and_return(forecast)
      source
    end

    before(:example) { Weather.configuration.source = source }
    after(:example) { Weather.configuration.source = nil }

    subject { described_class.call(options) }

    describe 'with no options' do
      let(:options) { [] }

      it 'shows help' do
        expect { subject }.to output(include('Usage: weather')).to_stdout
      end
    end

    describe 'with --help option' do
      let(:options) { %w[--help] }

      it 'shows help' do
        expect { subject }.to output(include('Usage: weather')).to_stdout
      end
    end

    describe 'with --version option' do
      let(:options) { %w[--version] }

      it 'shows version' do
        expect { subject }.to output(Weather::VERSION + "\n").to_stdout
      end
    end

    describe 'with --today option' do
      let(:options) { ['--today', city] }

      it 'shows maximum and minimum temperatures for today' do
        expect { subject }
            .to output(
                    "#{'%g' % ('%.2f' % maximums.first)}°C / #{'%g' % ('%.2f' % minimums.first)}°C\n"
                ).to_stdout
      end
    end

    describe 'with --maximum and --today options' do
      let(:options) { ['--maximum', '--today', city] }

      it 'shows maximum temperature for today' do
        expect { subject }.to output("#{'%g' % ('%.2f' % maximums.first)}°C\n").to_stdout
      end
    end

    describe 'with --minimum and --today options' do
      let(:options) { ['--minimum', '--today', city] }

      it 'shows minimum temperature for today' do
        expect { subject }.to output("#{'%g' % ('%.2f' % minimums.first)}°C\n").to_stdout
      end
    end

    describe 'with --average option' do
      let(:options) { ['--average', city] }

      it 'shows average maximum and minimum temperatures' do
        expect { subject }
            .to output(
                    "#{'%g' % ('%.2f' % average_maximum)}°C / #{'%g' % ('%.2f' % average_minimum)}°C\n"
                ).to_stdout
      end
    end

    describe 'with --maximum and --average options' do
      let(:options) { ['--maximum', '--average', city] }

      it 'shows average maximum temperature' do
        expect { subject }.to output("#{'%g' % ('%.2f' % average_maximum)}°C\n").to_stdout
      end
    end

    describe 'with --minimum and --average options' do
      let(:options) { ['--minimum', '--average', city] }

      it 'shows average minimum temperature' do
        expect { subject }.to output("#{'%g' % ('%.2f' % average_minimum)}°C\n").to_stdout
      end
    end
  end
end
