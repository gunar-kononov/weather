require 'weather/version'

module Weather
  autoload :Metrics, 'weather/metrics'
  autoload :Decorators, 'weather/decorators'
  autoload :CLI, 'weather/cli'

  class << self
    def configuration
      @configuration ||= Weather::Configuration.new
    end

    def configure
      yield configuration
    end
  end

  class Configuration
    attr_accessor :source, :access_key
  end

  class SourceError < ::StandardError; end
end
