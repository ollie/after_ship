# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'after_ship/version'

Gem::Specification.new do |spec|
  spec.name          = 'after_ship'
  spec.version       = AfterShip::VERSION
  spec.authors       = ['Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']
  spec.summary       = 'A smallish library to talking to AfterShip via v3 API.'
  spec.homepage      = 'https://github.com/ollie/after_ship'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  # System
  spec.add_development_dependency 'bundler', '~> 1.6'

  # Test
  spec.add_development_dependency 'rspec',     '~> 3.0'
  spec.add_development_dependency 'webmock',   '~> 1.18'
  spec.add_development_dependency 'simplecov', '~> 0.8'

  # Code style, debugging, docs
  spec.add_development_dependency 'rubocop', '~> 0.24'
  spec.add_development_dependency 'pry',     '~> 0.10'
  spec.add_development_dependency 'yard',    '~> 0.8'
  spec.add_development_dependency 'rake',    '~> 10.3'

  # Networking
  # Fast networking
  spec.add_runtime_dependency 'typhoeus',   '~> 0.6'
  # A common interface to multiple JSON libraries
  spec.add_runtime_dependency 'multi_json', '~> 1.10'
end
