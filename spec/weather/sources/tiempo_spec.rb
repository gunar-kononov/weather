require 'weather/sources/tiempo'

RSpec.describe Weather::Sources::Tiempo do
  let(:city) { 'Barcelona' }

  before(:context) do
    Weather.configure do |config|
      config.source = described_class
      config.access_key = described_class::AFFILIATE_ID
    end
  end

  after(:context) do
    Weather.configure do |config|
      config.source = nil
      config.access_key = nil
    end
  end

  subject { described_class.temperature(city) }

  describe '#temperature' do
    let(:province_query) do
      {
          api_lang: described_class::LANG,
          division: described_class::PROVINCE_ID,
          affiliate_id: described_class::AFFILIATE_ID
      }
    end

    let(:city_query) do
      {
          api_lang: described_class::LANG,
          localidad: described_class::CITY_ID,
          affiliate_id: described_class::AFFILIATE_ID
      }
    end

    describe 'when API requests are successful' do
      before(:example) do
        stub_request(:get, 'api.tiempo.com/index.php').with(query: province_query).
            to_return(status: 200, body: File.read('spec/weather/sources/tiempo/province.xml'))
      end

      before(:example) do
        stub_request(:get, 'api.tiempo.com/index.php').with(query: city_query).
            to_return(status: 200, body: File.read('spec/weather/sources/tiempo/city.xml'))
      end

      it 'returns correct data' do
        expect(subject).to be_an(Array).and have_attributes(size: 7).
            and all(be_an(Array).and have_attributes(size: 2).and all(be_an(Integer)))
      end
    end

    describe 'when API request fails' do
      shared_examples 'raises an error' do
        it 'raises an error' do
          expect { subject }.to raise_error Weather::SourceError
        end
      end

      describe 'as bad request' do
        before(:example) do
          stub_request(:get, 'api.tiempo.com/index.php').with(query: province_query).to_return(status: 400)
        end

        before(:example) do
          stub_request(:get, 'api.tiempo.com/index.php').with(query: city_query).to_return(status: 400)
        end

        include_examples 'raises an error'
      end

      describe 'as error' do
        before(:example) do
          stub_request(:get, 'api.tiempo.com/index.php').with(query: province_query).
              to_return(status: 200, body: File.read('spec/weather/sources/tiempo/error.xml'))
        end

        before(:example) do
          stub_request(:get, 'api.tiempo.com/index.php').with(query: city_query).
              to_return(status: 200, body: File.read('spec/weather/sources/tiempo/error.xml'))
        end

        include_examples 'raises an error'
      end

      describe 'as invalid province xml' do
        before(:example) do
          stub_request(:get, 'api.tiempo.com/index.php').with(query: province_query).
              to_return(status: 200, body: File.read('spec/weather/sources/tiempo/invalid.xml'))
        end

        before(:example) do
          stub_request(:get, 'api.tiempo.com/index.php').with(query: city_query).
              to_return(status: 200, body: File.read('spec/weather/sources/tiempo/city.xml'))
        end

        include_examples 'raises an error'
      end

      describe 'as invalid city xml' do
        before(:example) do
          stub_request(:get, 'api.tiempo.com/index.php').with(query: province_query).
              to_return(status: 200, body: File.read('spec/weather/sources/tiempo/province.xml'))
        end

        before(:example) do
          stub_request(:get, 'api.tiempo.com/index.php').with(query: city_query).
              to_return(status: 200, body: File.read('spec/weather/sources/tiempo/invalid.xml'))
        end

        include_examples 'raises an error'
      end
    end
  end
end
