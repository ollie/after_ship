require 'bundler/setup'

require 'simplecov'
require 'webmock' # Disable all HTTP access
require 'multi_json'

# Coverage tool, needs to be started as soon as possible
SimpleCov.start do
  add_filter '/spec/' # Ignore spec directory
end

require 'after_ship'
require 'request_stubs'
