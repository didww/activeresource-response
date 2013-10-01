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


require 'active_resource_response'
require "fixtures/country"
require "fixtures/city"
require "fixtures/region"
require "fixtures/street"

require "active_resource_response/http_mock"


#made pass lint test because of "to_key should return nil when `persisted?` returns false" error
require "active_resource_response/lint"
ActiveResource::Base.send :include, ActiveResourceResponse::Lint

class ActiveResourceResponseLintTest <  Test::Unit::TestCase

  include ActiveModel::Lint::Tests

   def setup
      @street = {:street => {:id => 1, :name => "Deribasovskaya", :population => 2300}}
      ActiveResource::HttpMock.respond_to do |mock|
         mock.get "/streets/1.json", {}, @street.to_json, 200, {"X-total"=>'1'}
     end
     @model = Street.find(1)
     
   end
end
  
