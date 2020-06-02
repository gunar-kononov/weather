RSpec.describe Weather::Decorators::Temperature do
  let(:today_minimum) { Faker::Number.within(range: -50..0) }
  let(:today_maximum) { Faker::Number.within(range: 0..50) }
  let(:average_minimum) { Faker::Number.within(range: -50.0..0.0) }
  let(:average_maximum) { Faker::Number.within(range: 0.0..50.0) }

  let(:temperature) do
    temperature = double
    allow(temperature).to receive(:today_minimum).and_return(today_minimum)
    allow(temperature).to receive(:today_maximum).and_return(today_maximum)
    allow(temperature).to receive(:average_minimum).and_return(average_minimum)
    allow(temperature).to receive(:average_maximum).and_return(average_maximum)
    temperature
  end

  subject { described_class.new(temperature) }

  describe '#today' do
    it 'returns correct value' do
      expect(subject.today).to eq "#{'%g' % ('%.2f' % today_maximum)}°C / #{'%g' % ('%.2f' % today_minimum)}°C"
    end
  end

  describe '#today_maximum' do
    it 'returns correct value' do
      expect(subject.today_maximum).to eq "#{'%g' % ('%.2f' % today_maximum)}°C"
    end
  end

  describe '#today_minimum' do
    it 'returns correct value' do
      expect(subject.today_minimum).to eq "#{'%g' % ('%.2f' % today_minimum)}°C"
    end
  end

  describe '#average' do
    it 'returns correct value' do
      expect(subject.average).to eq "#{'%g' % ('%.2f' % average_maximum)}°C / #{'%g' % ('%.2f' % average_minimum)}°C"
    end
  end

  describe '#average_maximum' do
    it 'returns correct value' do
      expect(subject.average_maximum).to eq "#{'%g' % ('%.2f' % average_maximum)}°C"
    end
  end

  describe '#average_minimum' do
    it 'returns correct value' do
      expect(subject.average_minimum).to eq "#{'%g' % ('%.2f' % average_minimum)}°C"
    end
  end
end
