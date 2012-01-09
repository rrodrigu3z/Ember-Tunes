# Setup test environment
ENV['RACK_ENV'] = 'test'

$: << File.dirname(__FILE__) + "/../lib"
require "init"
require 'test/unit'
require "rack/test"

require "server"

Barista.logger.level = Logger::WARN