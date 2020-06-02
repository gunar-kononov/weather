require 'net/http'
require 'uri/http'
require 'uri/common'
require 'rexml/document'
require 'i18n'

module Weather
  module Sources
    class Tiempo
      # https://www.tiempo.com/api/

      HOST = 'api.tiempo.com'.freeze
      PATH = '/index.php'.freeze
      LANG = 'en'.freeze
      PROVINCE_ID = 102.freeze
      CITY_ID = 1200.freeze
      AFFILIATE_ID = '1y39rce9zloh'.freeze

      attr_reader :city

      def initialize(city)
        @city = city
      end

      def self.temperature(city)
        new(city).temperature
      end

      def temperature
        @temperature ||=
            begin
              text = get city_url
              xml = parse text
              minimums = []
              maximums = []
              xml.elements.each('report/location/var') do |var|
                var_name = REXML::XPath.first(var, 'name').text
                if var_name == 'Minimum Temperature'
                  var.elements.each('data/forecast') { |forecast| minimums << forecast }
                end
                if var_name == 'Maximum Temperature'
                  var.elements.each('data/forecast') { |forecast| maximums << forecast }
                end
              end
              raise SourceError.new('Failed to get data from source') if minimums.empty? || maximums.empty?
              data_sequence = -> (element) { element.attributes['data_sequence'].to_i }
              value = -> (element) { element.attributes['value'].to_i }
              minimums.sort_by!(&data_sequence).map!(&value)
              maximums.sort_by!(&data_sequence).map!(&value)
              minimums.zip(maximums)
            end
      end

      private

      def city_id
        text = get province_url
        xml = parse text
        id = nil
        xml.elements.each('report/location/data/name') do |location_name|
          if I18n.transliterate(location_name.text) == city
            id = location_name.attributes['id']
          end
        end
        raise SourceError.new('Failed to get data from source') if id.nil?
        id
      end

      def get(url)
        response = Net::HTTP.get_response(url)
        raise SourceError.new('Failed to get a response from source') unless response.code == '200'
        response.body
      end

      def parse(text)
        xml = REXML::Document.new(text)
        error = REXML::XPath.first(xml, 'report/error')
        raise SourceError.new("Got an error response from source: #{error.text}") unless error.nil?
        xml
      end

      def province_url
        URI::HTTP.build(host: HOST, path: PATH, query: query_params('division', PROVINCE_ID))
      end

      def city_url
        URI::HTTP.build(host: HOST, path: PATH, query: query_params('localidad', city_id))
      end

      def query_params(key, value)
        URI.encode_www_form(affiliate_id: Weather.configuration.access_key, api_lang: LANG, key => value)
      end
    end
  end
end
