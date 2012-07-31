

lib = File.expand_path("#{File.dirname(__FILE__)}/../lib")
test = File.expand_path("#{File.dirname(__FILE__)}/../test")
$:.unshift(lib)
$:.unshift(test)

require 'test/unit'
require 'active_resource'
require 'activeresource-response'
require 'active_resource/http_mock' 
require "fixtures/country"


class ActiveResource::Response
  
  def to_hash
    @headers
  end
  
end

class ActiveResourceResponseTest < Test::Unit::TestCase
 
 
   def setup
     @country = { :country => { :id => 1, :name => "Ukraine", :iso=>"UA" } }
     ActiveResource::HttpMock.respond_to do |mock|
       mock.get "/countries.json", {}, [@country].to_json, 200, {"X-total"=>'1'}
       mock.get "/countries/1.json", {}, @country.to_json, 200, {"X-total"=>'1'}
       mock.get "/countries/1/count.json",{}, {:count => 1155}.to_json, 200 , {"X-total"=>'1'}
     end
     
   end  
   
   
  def test_get_headers_from_all
    countries = Country.all
    assert_kind_of Country, countries.first
    assert_equal "UA", countries.first.iso
    assert countries.respond_to?(:http)
    assert_equal countries.http[:x_total].to_i, 1

  end
  
  
  def test_get_headers_from_custom_methods
    count = Country.find(1).get("count")
    assert_equal count.to_i, 1155
    assert_equal Country.connection.http_response[:x_total].to_i, 1
  end


   def test_get_headers_from_find
     country = Country.find(1)
     assert_equal country.http[:x_total].to_i, 1
   end

  
  
end
