module Weather
  module Metrics
    class Temperature
      attr_reader :city

      def initialize(city)
        @city = city
      end

      def today
        [today_maximum, today_minimum]
      end

      def today_maximum
        forecast.first.max
      end

      def today_minimum
        forecast.first.min
      end

      def average
        [average_maximum, average_minimum]
      end

      def average_maximum
        maximum = forecast.map(&:max)
        maximum.sum(0.0) / maximum.length
      end

      def average_minimum
        minimum = forecast.map(&:min)
        minimum.sum(0.0) / minimum.length
      end

      def forecast
        Weather.configuration.source.temperature(city)
      end

      def decorated
        Weather::Decorators::Temperature.new(self)
      end
    end
  end
end
