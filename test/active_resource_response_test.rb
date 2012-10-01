lib = File.expand_path("#{File.dirname(__FILE__)}/../lib")
unit_tests = File.expand_path("#{File.dirname(__FILE__)}/../test")
$:.unshift(lib)
$:.unshift(unit_tests)

require 'test/unit'
require 'active_resource'
require 'active_resource/http_mock'
require 'active_resource_response'
require "fixtures/country"


class ActiveResourceResponseTest < Test::Unit::TestCase


  def setup

    @country = {:country => {:id => 1, :name => "Ukraine", :iso=>"UA"}}
    @city = {:city => {:id => 1, :name => "Odessa", :population => 2500000 }}
    ActiveResource::HttpMock.respond_to do |mock|
      
     
      mock.get "/countries.json", {}, [@country].to_json, 200, {"X-total"=>'1'}
      mock.get "/countries/1.json", {}, @country.to_json, 200, {"X-total"=>'1', 'Set-Cookie'=>['path=/; expires=Tue, 20-Jan-2015 15:03:14 GMT, foo=bar, bar=foo']}
      mock.get "/countries/1/population.json", {}, {:count => 45000000}.to_json, 200, {"X-total"=>'1'}
      mock.post "/countries.json" , {},   @country.to_json, 422, {"X-total"=>'1'}
      mock.get "/countries/1/cities.json", {}, [@city].to_json, 200, {"X-total"=>'1'}
    end





  end


  def test_methods_appeared
    countries = Country.all
    assert countries.respond_to?(:http)
    assert countries.http.respond_to?(:cookies)
    assert countries.http.respond_to?(:headers)
    assert Country.respond_to?(:http_response)
  end

  def test_get_headers_from_all
    countries = Country.all
    assert_kind_of Country, countries.first
    assert_equal "UA", countries.first.iso

    assert_equal countries.http['X-total'].to_i, 1
    assert_equal countries.http.headers[:x_total].to_i, 1

  end


  def test_get_headers_from_custom_methods
    count = Country.find(1).get("population")    
    assert_equal count.to_i, 45000000
    assert_equal Country.connection.http_response['X-total'].to_i, 1
    assert_equal Country.connection.http_response.headers[:x_total].to_i, 1
    assert_equal Country.http_response['X-total'].to_i ,1
    
   
    
    cities = Country.find(1).get("cities")
    assert cities.respond_to?(:http)
    assert_equal cities.http['X-total'].to_i, 1  


  end


  def test_get_headers_from_find
    country = Country.find(1)
    assert_equal country.http['X-total'].to_i, 1
    assert_equal country.http.headers[:x_total].to_i, 1

  end


  def test_get_cookies
    country = Country.find(1)
    assert_equal country.http.cookies['foo'] ,  'bar'
    assert_equal country.http.cookies['bar'] ,  'foo'
    #from class
    assert_equal Country.http_response.cookies['foo'] ,  'bar'
    assert_equal Country.http_response.cookies['bar'] ,  'foo'

  end


  def test_get_headers_after_exception
     Country.create(@country[:country])
     assert_equal Country.http_response['X-total'].to_i, 1
     assert_equal Country.http_response.code, 422
  end


end
