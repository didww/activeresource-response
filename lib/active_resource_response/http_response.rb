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
module ActiveResourceResponse
  module HttpResponse
    
    def headers
      unless defined? @_active_resource_response_headers
        @_active_resource_response_headers = symbolize_keys(to_hash)
      end
      @_active_resource_response_headers
    end
         
    def cookies
      unless defined? @_active_resource_response_cookies
        @_active_resource_response_cookies    = (self.headers[:set_cookie] || {}).inject({}) do |out, cookie_str|
          CGI::Cookie::parse(cookie_str).each do |key, cookie|
            out[key] = cookie.value.first unless ['expires', 'path'].include? key
          end
          out
        end
      end
      @_active_resource_response_cookies
    end

    private
    def symbolize_keys(hash)
      hash.inject({}) do |out, (key, value)|
        out[key.gsub(/-/, '_').downcase.to_sym] = value
        out
      end
    end   
       
  end
end