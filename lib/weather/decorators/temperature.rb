module Weather
  module Decorators
    class Temperature
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def today
        "#{today_maximum} / #{today_minimum}"
      end

      def today_maximum
        decorate object.today_maximum
      end

      def today_minimum
        decorate object.today_minimum
      end

      def average
        "#{average_maximum} / #{average_minimum}"
      end

      def average_maximum
        decorate object.average_maximum
      end

      def average_minimum
        decorate object.average_minimum
      end

      def decorate(temperature)
        "#{format temperature}°C"
      end

      def format(temperature)
        sprintf('%g', sprintf('%.2f', temperature))
      end
    end
  end
end
