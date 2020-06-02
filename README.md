# Weather

Weather of the cities of Barcelona.

Provides average of the minimum and maximum temperature during the week, and the temperature of the day.

## Installation

```ruby
gem 'weather', git: 'https://github.com/gunar-kononov/weather'
```

## Usage

Run `bin/weather -h` for detailed command line usage information.

Also available in your application:

```ruby
Weather::Metrics::Temperature.new('Barcelona')
```

## Development

After checking out the repo, run `bundle install` to install dependencies.
Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run `bundle exec rake install`.
