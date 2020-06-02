require 'optparse'
require 'i18n'

module Weather
  module CLI
    class << self
      def call(argv)
        options = {}
        OptionParser.new do |op|
          options[:parser] = op

          op.banner = 'Usage: weather [options]'

          op.on('-x', '--maximum', 'Show maximum temperature; use together with -t or -a')
          op.on('-n', '--minimum', 'Show minimum temperature; use together with -t or -a')

          op.on('-t', '--today [CITY]', String, 'Show temperature of the day in specified city') do |city|
            options[:city] = I18n.transliterate(city || 'Barcelona')
            options[:today] = true
          end

          op.on('-a', '--average [CITY]', String, 'Show average temperature in specified city') do |city|
            options[:city] = I18n.transliterate(city || 'Barcelona')
            options[:average] = true
          end

          op.on_tail('-h', '--help', 'Show this message')
          op.on_tail('-v', '--version', 'Show version')
        end.parse!(argv, into: options)

        case true
        when options[:help]
          puts options[:parser]
        when options[:version]
          puts Weather::VERSION
        when options[:today]
          temperature = Weather::Metrics::Temperature.new(options[:city]).decorated
          if options[:maximum] == options[:minimum]
            puts temperature.today
          elsif options[:maximum]
            puts temperature.today_maximum
          else
            puts temperature.today_minimum
          end
        when options[:average]
          temperature = Weather::Metrics::Temperature.new(options[:city]).decorated
          if options[:maximum] == options[:minimum]
            puts temperature.average
          elsif options[:maximum]
            puts temperature.average_maximum
          else
            puts temperature.average_minimum
          end
        else
          puts options[:parser]
        end
      end
    end
  end
end
