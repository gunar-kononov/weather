require_relative 'lib/weather/version'

Gem::Specification.new do |gem|
  gem.name = 'weather'
  gem.version = Weather::VERSION
  gem.author = 'Gunar Kononov'
  gem.email = 'gunar.kononov@gmail.com'

  gem.summary = 'Weather of the cities of Barcelona'
  gem.description = <<~EOF
    Weather of the cities of Barcelona.
    Provides average of the minimum and maximum temperature during the week, and the temperature of the day.
  EOF
  gem.homepage = 'https://github.com/gunar-kononov/weather'
  gem.license = 'MIT'
  gem.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  gem.files = Dir.glob(File.join('lib', '**', '*.rb')) + %w(LICENSE.txt README.md)
  gem.executables = ['weather']
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'i18n'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'faker'
  gem.add_development_dependency 'webmock'
end
