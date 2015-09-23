# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'after_ship/core/version'

Gem::Specification.new do |spec|
  spec.name          = 'after_ship'
  spec.version       = AfterShip::VERSION
  spec.authors       = ['Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']

  spec.summary       = 'A smallish library to talking to AfterShip via v4 API.'
  spec.homepage      = 'https://github.com/ollie/after_ship'
  spec.license       = 'MIT'

  # rubocop:disable Metrics/LineLength
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # System
  spec.add_development_dependency 'bundler', '~> 1.10'

  # Test
  spec.add_development_dependency 'rspec',     '~> 3.3'
  spec.add_development_dependency 'webmock',   '~> 1.21'
  spec.add_development_dependency 'simplecov', '~> 0.10'

  # Code style, debugging, docs
  spec.add_development_dependency 'rubocop', '~> 0.34'
  spec.add_development_dependency 'pry',     '~> 0.10'
  spec.add_development_dependency 'yard',    '~> 0.8'
  spec.add_development_dependency 'rake',    '~> 10.4'

  # Networking
  # Fast networking
  spec.add_runtime_dependency 'typhoeus',   '~> 0.8'
  # A common interface to multiple JSON libraries
  spec.add_runtime_dependency 'multi_json', '~> 1.11'
end
