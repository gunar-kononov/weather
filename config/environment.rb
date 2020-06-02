Weather.configure do |config|
  config.source = Weather::Sources::Tiempo
  # Prefer not to use hardcoded credentials. Default provided for testing purposes.
  config.access_key = ENV['ACCESS_KEY'] || Weather::Sources::Tiempo::AFFILIATE_ID
end

I18n.config.enforce_available_locales = false
