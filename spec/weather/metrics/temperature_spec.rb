RSpec.describe Weather::Metrics::Temperature do
  let(:minimums) do
    Array.new(7) { Faker::Number.within(range: -50..0) }
  end

  let(:maximums) do
    Array.new(7) { Faker::Number.within(range: 0..50) }
  end

  let(:forecast) { minimums.zip(maximums) }
  let(:city) { 'Barcelona' }

  let(:source) do
    source = double
    allow(source).to receive(:temperature).with(city).and_return(forecast)
    source
  end

  before(:example) { Weather.configuration.source = source }
  after(:example) { Weather.configuration.source = nil }

  subject { described_class.new(city) }

  describe '#today' do
    it 'returns correct value' do
      expect(subject.today).to eq [maximums.first, minimums.first]
    end
  end

  describe '#today_maximum' do
    it 'returns correct value' do
      expect(subject.today_maximum).to eq maximums.first
    end
  end

  describe '#today_minimum' do
    it 'returns correct value' do
      expect(subject.today_minimum).to eq minimums.first
    end
  end

  describe '#average' do
    it 'returns correct value' do
      expect(subject.average).to eq [maximums.sum(0.0) / maximums.length, minimums.sum(0.0) / minimums.length]
    end
  end

  describe '#average_maximum' do
    it 'returns correct value' do
      expect(subject.average_maximum).to eq maximums.sum(0.0) / maximums.length
    end
  end

  describe '#average_minimum' do
    it 'returns correct value' do
      expect(subject.average_minimum).to eq minimums.sum(0.0) / minimums.length
    end
  end

  describe '#forecast' do
    it 'returns correct value' do
      expect(subject.forecast).to eq forecast
    end
  end

  describe '#decorated' do
    it 'returns correct value' do
      expect(subject.decorated).to be_an_instance_of Weather::Decorators::Temperature
    end
  end
end
