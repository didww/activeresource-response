#--
# Copyright (c) 2012 Igor Fedoronchuk
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

lib = File.expand_path("#{File.dirname(__FILE__)}/../lib")
unit_tests = File.expand_path("#{File.dirname(__FILE__)}/../test")
$:.unshift(lib)
$:.unshift(unit_tests)

require 'test/unit'
require 'active_resource_response'
require "fixtures/country"
require "fixtures/city"
require "fixtures/region"
require "fixtures/street"

class ActiveResourceResponseTest < Test::Unit::TestCase


  def setup
    @country = {:country => {:id => 1, :name => "Ukraine", :iso=>"UA"}}
    @city = {:city => {:id => 1, :name => "Odessa", :population => 2500000}}
    @region = {:region => {:id => 1, :name => "Odessa region", :population => 4500000}}
    @street = {:street => {:id => 1, :name => "Deribasovskaya", :population => 2300}}
    
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/countries.json", {}, [@country].to_json, 200, {"X-total"=>'1'}
      mock.get "/regions.json", {}, [@region].to_json, 200, {"X-total"=>'1'}
      mock.get "/regions/1.json", {}, @region.to_json, 200, {"X-total"=>'1'}
      mock.get "/regions/population.json", {}, {:count => 45000000}.to_json, 200, {"X-total"=>'1'}
      mock.get "/regions/cities.json", {}, [@city].to_json, 200, {"X-total"=>'2'}
      mock.get "/countries/1.json", {}, @country.to_json, 200, {"X-total"=>'1', 'Set-Cookie'=>['path=/; expires=Tue, 20-Jan-2015 15:03:14 GMT, foo=bar, bar=foo']}
      mock.get "/countries/1/population.json", {}, {:count => 45000000}.to_json, 200, {"X-total"=>'1'}
      mock.post "/countries.json", {}, @country.to_json, 422, {"X-total"=>'1'}
      mock.get "/countries/1/cities.json", {}, [@city].to_json, 200, {"X-total"=>'1'}
      mock.get "/regions/1/cities.json", {}, [@city].to_json, 200, {"X-total"=>'1'}
      mock.get "/cities/1/population.json", {}, {:count => 2500000}.to_json, 200, {"X-total"=>'1'}
      mock.get "/cities/1.json", {}, @city.to_json, 200, {"X-total"=>'1'}
      mock.get "/cities.json", {}, [@city].to_json, 200, {"X-total"=>'1'}
      mock.get "/streets.json", {}, [@street].to_json, 200, {"X-total"=>'1'}
      mock.get "/streets/1/city.json", {}, @city.to_json, 200, {"X-total"=>'1'}
      mock.get "/streets/1.json", {}, @street.to_json, 200, {"X-total"=>'1'}
    end
  end


  def test_methods_appeared
    countries = Country.all
    assert countries.respond_to?(:http)
    assert countries.http.respond_to?(:cookies)
    assert countries.http.respond_to?(:headers)
    assert Country.respond_to?(:http_response)
    regions = Region.all
    assert regions.respond_to?(:http_response)
  end

  def test_get_headers_from_all
    countries = Country.all
    assert_kind_of Country, countries.first
    assert_equal "UA", countries.first.iso
    assert_equal countries.http.headers[:x_total].to_i, 1
  end


  def test_get_headers_from_custom_methods
    cities = Region.get("cities")
    assert cities.respond_to?(:http_response)
    assert_equal cities.http_response.headers[:x_total].to_i, 2
    count = Country.find(1).get("population")

    #immutable objects doing good
    some_numeric = 45000000
    assert_equal count.to_i, some_numeric
    assert count.respond_to?(:http)
    assert !some_numeric.respond_to?(:http)

    assert_equal Country.connection.http_response.headers[:x_total].to_i, 1
    assert_equal Country.http_response.headers[:x_total].to_i, 1
    cities = Country.find(1).get("cities")
    assert cities.respond_to?(:http), "Cities should respond to http"
    assert_equal cities.http.headers[:x_total].to_i, 1, "Cities total value should be 1"
    regions_population = Region.get("population")
    assert_equal regions_population.to_i, 45000000
    cities = Region.find(1).get("cities")
    assert cities.respond_to?(:http_response)
    assert_equal cities.http_response.headers[:x_total].to_i, 1

  end


  def test_methods_without_http
    cities = City.all
    assert_kind_of City, cities.first
    count = cities.first.get("population")
    assert_equal count.to_i, 2500000

  end

  def test_get_headers_from_find
    country = Country.find(1)
    assert_equal country.http.headers[:x_total].to_i, 1
  end

  def test_get_cookies
    country = Country.find(1)
    assert_equal country.http.cookies['foo'], 'bar'
    assert_equal country.http.cookies['bar'], 'foo'
    #from class
    assert_equal Country.http_response.cookies['foo'], 'bar'
    assert_equal Country.http_response.cookies['bar'], 'foo'

  end

  def test_get_headers_after_exception
    Country.create(@country[:country])
    assert_equal Country.http_response.headers[:x_total].to_i, 1
    assert_equal Country.http_response.code, 422
  end

  def test_remove_method
     street  = Street.find(:first)
     assert !(street.respond_to?(ActiveResourceResponseBase.http_response_method))
     city = Street.find(1).get('city')
     assert !(city.respond_to?(ActiveResourceResponseBase.http_response_method))
     #test if all ok in base class
     country = Country.find(1)
     assert country.respond_to?(Country.http_response_method)
     region = Region.find(1)
     assert region.respond_to?(ActiveResourceResponseBase.http_response_method)
  end

end
