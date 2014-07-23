require 'minitest/autorun'
require 'coveralls'
require 'i18n'
lib = File.expand_path("#{File.dirname(__FILE__)}/../lib")
unit_tests = File.expand_path("#{File.dirname(__FILE__)}/../test")
$:.unshift(lib)
$:.unshift(unit_tests)


require 'active_resource_response'
require "fixtures/country"
require "fixtures/city"
require "fixtures/region"
require "fixtures/street"
require "active_resource_response/http_mock"

I18n.config.enforce_available_locales = true
Coveralls.wear!