require 'bundler'
Bundler.setup
Bundler.require

run Rack::Jekyll.new
